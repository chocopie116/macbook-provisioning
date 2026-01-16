#!/usr/bin/env bun
import { Client } from "@notionhq/client";
import { parse } from "yaml";
import { readFileSync } from "fs";
import { join, dirname } from "path";
import type {
  PageObjectResponse,
  BlockObjectResponse,
  RichTextItemResponse,
} from "@notionhq/client/build/src/api-endpoints";

// Load databases config
interface DatabaseConfig {
  id: string;
  description: string;
}

interface DatabasesConfig {
  databases: Record<string, DatabaseConfig>;
}

function loadDatabases(): DatabasesConfig {
  const configPath = join(dirname(import.meta.path), "databases.yaml");
  const content = readFileSync(configPath, "utf-8");
  return parse(content) as DatabasesConfig;
}

const notion = new Client({
  auth: process.env.NOTION_API_KEY,
});

// Config constants
const CONFIG = {
  PAGE_SIZE_LIST: 20,
  PAGE_SIZE_BLOCKS: 100,
  PROP_VALUE_TRUNCATE: 50,
  PROP_DISPLAY_LIMIT: 3,
} as const;

// Helper: Extract plain text from rich text
function richTextToPlain(richText: RichTextItemResponse[]): string {
  return richText.map((t) => t.plain_text).join("");
}

// Helper: Convert Notion blocks to Markdown
function blocksToMarkdown(blocks: BlockObjectResponse[]): string {
  const lines: string[] = [];

  for (const block of blocks) {
    switch (block.type) {
      case "paragraph":
        lines.push(richTextToPlain(block.paragraph.rich_text));
        lines.push("");
        break;
      case "heading_1":
        lines.push(`# ${richTextToPlain(block.heading_1.rich_text)}`);
        lines.push("");
        break;
      case "heading_2":
        lines.push(`## ${richTextToPlain(block.heading_2.rich_text)}`);
        lines.push("");
        break;
      case "heading_3":
        lines.push(`### ${richTextToPlain(block.heading_3.rich_text)}`);
        lines.push("");
        break;
      case "bulleted_list_item":
        lines.push(`- ${richTextToPlain(block.bulleted_list_item.rich_text)}`);
        break;
      case "numbered_list_item":
        lines.push(`1. ${richTextToPlain(block.numbered_list_item.rich_text)}`);
        break;
      case "to_do":
        const checked = block.to_do.checked ? "x" : " ";
        lines.push(`- [${checked}] ${richTextToPlain(block.to_do.rich_text)}`);
        break;
      case "toggle":
        lines.push(`> ${richTextToPlain(block.toggle.rich_text)}`);
        break;
      case "code":
        const lang = block.code.language || "";
        lines.push(`\`\`\`${lang}`);
        lines.push(richTextToPlain(block.code.rich_text));
        lines.push("```");
        lines.push("");
        break;
      case "quote":
        lines.push(`> ${richTextToPlain(block.quote.rich_text)}`);
        lines.push("");
        break;
      case "divider":
        lines.push("---");
        lines.push("");
        break;
      case "callout":
        const icon =
          block.callout.icon?.type === "emoji" ? block.callout.icon.emoji : "";
        lines.push(`> ${icon} ${richTextToPlain(block.callout.rich_text)}`);
        lines.push("");
        break;
      default:
        break;
    }
  }

  return lines.join("\n").trim();
}

// List registered databases
function listDatabases(): void {
  const config = loadDatabases();
  console.log("Registered databases:\n");
  for (const [name, db] of Object.entries(config.databases)) {
    console.log(`  ${name}: ${db.description}`);
    console.log(`    ID: ${db.id}`);
    console.log("");
  }
}

// Get database ID by name
function getDatabaseId(name: string): string | undefined {
  const config = loadDatabases();
  return config.databases[name]?.id;
}

// Get database schema
async function getDatabaseSchema(databaseId: string): Promise<void> {
  const db = await notion.databases.retrieve({ database_id: databaseId });
  console.log("Database properties:\n");
  for (const [name, prop] of Object.entries(db.properties)) {
    console.log(`  ${name}: ${prop.type}`);
  }
}

// Extract property value as string
function extractPropertyValue(prop: PageObjectResponse["properties"][string]): string {
  switch (prop.type) {
    case "title":
      return richTextToPlain(prop.title);
    case "rich_text":
      return richTextToPlain(prop.rich_text);
    case "number":
      return prop.number?.toString() ?? "";
    case "select":
      return prop.select?.name ?? "";
    case "multi_select":
      return prop.multi_select.map((s) => s.name).join(", ");
    case "date":
      return prop.date?.start ?? "";
    case "checkbox":
      return prop.checkbox ? "true" : "false";
    case "url":
      return prop.url ?? "";
    case "email":
      return prop.email ?? "";
    case "phone_number":
      return prop.phone_number ?? "";
    case "created_time":
      return prop.created_time;
    case "last_edited_time":
      return prop.last_edited_time;
    case "relation":
      return prop.relation.map((r) => r.id).join(", ");
    case "formula":
      if (prop.formula.type === "string") return prop.formula.string ?? "";
      if (prop.formula.type === "number") return prop.formula.number?.toString() ?? "";
      if (prop.formula.type === "boolean") return prop.formula.boolean?.toString() ?? "";
      if (prop.formula.type === "date") return prop.formula.date?.start ?? "";
      return "";
    case "status":
      return prop.status?.name ?? "";
    default:
      return "";
  }
}

// Extract title from page properties
function extractTitle(properties: PageObjectResponse["properties"]): string {
  for (const prop of Object.values(properties)) {
    if (prop.type === "title") {
      return richTextToPlain(prop.title) || "Untitled";
    }
  }
  return "Untitled";
}

// Format property summary (non-title properties)
function formatPropertySummary(
  properties: PageObjectResponse["properties"],
  truncate: number = CONFIG.PROP_VALUE_TRUNCATE,
  limit: number = CONFIG.PROP_DISPLAY_LIMIT
): string[] {
  const props: string[] = [];
  for (const [name, prop] of Object.entries(properties)) {
    if (prop.type === "title") continue;
    const value = extractPropertyValue(prop);
    if (value) {
      props.push(`${name}: ${value.length > truncate ? value.slice(0, truncate) + "..." : value}`);
    }
  }
  return props.slice(0, limit);
}

// Query options
interface QueryOptions {
  limit?: number;
  brief?: boolean;
}

// Query database pages
async function queryDatabase(databaseId: string, options: QueryOptions = {}): Promise<void> {
  const pageSize = options.limit ?? CONFIG.PAGE_SIZE_LIST;
  const response = await notion.databases.query({
    database_id: databaseId,
    page_size: pageSize,
  });

  if (options.brief) {
    // Brief mode: ID + title only
    for (const page of response.results) {
      if (!("properties" in page)) continue;
      const p = page as PageObjectResponse;
      const title = extractTitle(p.properties);
      console.log(`${p.id}\t${title}`);
    }
  } else {
    // Full mode
    console.log(`Found ${response.results.length} pages:\n`);

    for (const page of response.results) {
      if (!("properties" in page)) continue;
      const p = page as PageObjectResponse;
      const title = extractTitle(p.properties);

      console.log(`- ${title}`);
      console.log(`  ID: ${p.id}`);
      console.log(`  URL: ${p.url}`);

      const props = formatPropertySummary(p.properties);
      if (props.length > 0) {
        console.log(`  Properties: ${props.join(" | ")}`);
      }
      console.log("");
    }
  }
}

// Get page content
async function getPageContent(pageId: string): Promise<BlockObjectResponse[]> {
  const blocks: BlockObjectResponse[] = [];
  let cursor: string | undefined;

  do {
    const response = await notion.blocks.children.list({
      block_id: pageId,
      start_cursor: cursor,
      page_size: CONFIG.PAGE_SIZE_BLOCKS,
    });

    for (const block of response.results) {
      if ("type" in block) {
        blocks.push(block as BlockObjectResponse);
      }
    }

    cursor = response.has_more ? response.next_cursor ?? undefined : undefined;
  } while (cursor);

  return blocks;
}

// Get page with content as Markdown
async function getPage(pageId: string): Promise<void> {
  // Get page info
  const page = (await notion.pages.retrieve({ page_id: pageId })) as PageObjectResponse;

  const title = extractTitle(page.properties);
  console.log(`# ${title}\n`);
  console.log(`URL: ${page.url}\n`);

  // Show properties (full, no truncation for single page view)
  console.log("## Properties\n");
  for (const [name, prop] of Object.entries(page.properties)) {
    if (prop.type === "title") continue;
    const value = extractPropertyValue(prop);
    if (value) {
      console.log(`- **${name}**: ${value}`);
    }
  }
  console.log("");

  // Get content
  const blocks = await getPageContent(pageId);
  const content = blocksToMarkdown(blocks);

  console.log("## Content\n");
  console.log(content);
}

// Parse CLI option value
function getOptionValue(args: string[], option: string): string | undefined {
  const idx = args.indexOf(option);
  if (idx !== -1 && idx + 1 < args.length) {
    const value = args[idx + 1];
    if (!value.startsWith("--")) return value;
  }
  return undefined;
}

// CLI
async function main() {
  const args = process.argv.slice(2);

  // Show registered databases
  if (args.includes("--list") && args.length === 1) {
    listDatabases();
    return;
  }

  // Get page content
  const pageId = getOptionValue(args, "--page");
  if (args.includes("--page")) {
    if (!pageId) {
      console.error("Error: --page requires a page ID");
      process.exit(1);
    }
    await getPage(pageId);
    return;
  }

  // Database operations
  const dbName = args.find((a) => !a.startsWith("--") && args[args.indexOf(a) - 1] !== "--limit");
  if (dbName) {
    const databaseId = getDatabaseId(dbName);
    if (!databaseId) {
      console.error(`Error: Database "${dbName}" not found`);
      console.error("Use --list to see registered databases");
      process.exit(1);
    }

    // Show schema
    if (args.includes("--schema")) {
      await getDatabaseSchema(databaseId);
      return;
    }

    // Parse options
    const options: QueryOptions = {
      brief: args.includes("--brief"),
    };
    const limitStr = getOptionValue(args, "--limit");
    if (limitStr) {
      const limit = parseInt(limitStr, 10);
      if (!isNaN(limit) && limit > 0) {
        options.limit = limit;
      }
    }

    // Query database
    await queryDatabase(databaseId, options);
    return;
  }

  // Show usage
  console.log("Usage:");
  console.log("  bun run fetch-notion.ts --list                    # Show registered databases");
  console.log("  bun run fetch-notion.ts <db-name>                 # List pages in database");
  console.log("  bun run fetch-notion.ts <db-name> --schema        # Show database schema");
  console.log("  bun run fetch-notion.ts <db-name> --brief         # Brief output (ID + title)");
  console.log("  bun run fetch-notion.ts <db-name> --limit 5       # Limit results");
  console.log("  bun run fetch-notion.ts <db-name> --brief --limit 3");
  console.log("  bun run fetch-notion.ts --page <page-id>          # Get page content");
}

main().catch(console.error);
