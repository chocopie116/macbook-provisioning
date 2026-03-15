#!/bin/bash
set -e

REPO_URL="https://github.com/chocopie116/macbook-provisioning.git"
REPO_DIR="$HOME/ghq/github.com/chocopie116/macbook-provisioning"

echo "==> macOS provisioning start"

# 1. Xcode Command Line Tools
if ! xcode-select -p &>/dev/null; then
  echo "==> Installing Xcode Command Line Tools..."
  xcode-select --install
  echo "インストール完了後、このスクリプトを再実行してください"
  exit 0
fi

# 2. Homebrew
if ! command -v brew &>/dev/null; then
  echo "==> Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  # Apple Silicon
  if [ -f /opt/homebrew/bin/brew ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  fi
fi

# 3. Clone repository
if [ ! -d "$REPO_DIR" ]; then
  echo "==> Cloning repository..."
  mkdir -p "$(dirname "$REPO_DIR")"
  git clone "$REPO_URL" "$REPO_DIR"
else
  echo "==> Repository already exists, pulling latest..."
  git -C "$REPO_DIR" pull
fi

cd "$REPO_DIR"

# 4. Brew bundle
echo "==> Installing packages via Homebrew..."
brew bundle

# 5. Symlink configs
echo "==> Linking config files..."
make link

# 6. Yazi plugins
if command -v ya &>/dev/null; then
  echo "==> Installing yazi plugins..."
  ya pkg install
fi

# 7. macOS defaults
echo "==> Applying macOS defaults..."
bash macos/defaults.sh

echo ""
echo "==> Done! ターミナルを再起動してください"
