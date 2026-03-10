#!/usr/bin/env bash
# Install script for AI OS workspace.  Can be run as a one-liner via curl:
#
#   curl -fsSL https://raw.githubusercontent.com/BTSLAB/ai-os/main/install.sh | bash
#
# By default the workspace is cloned to /opt/ai-os; you can provide a
# different directory as the first argument.

set -euo pipefail

DEST=${1:-/opt/ai-os}

if [ -d "$DEST" ]; then
  echo "Destination $DEST already exists - aborting" >&2
  exit 1
fi

echo "Cloning AI OS repository into $DEST..."
git clone https://github.com/BTSLAB/ai-os.git "$DEST"
cd "$DEST"

# install global CLI wrapper
if command -v npm >/dev/null 2>&1; then
  echo "Installing npm package globally..."
  npm install -g .
else
  echo "npm not found; please install Node/npm to get the CLI wrapper." >&2
fi

cat <<'EOF'

Installation complete!

Next steps:
  1. Set the AIOS_CMD environment variable to point at your AI runtime CLI,
     e.g. export AIOS_CMD="/usr/local/bin/your-runtime-cli"
     (add it to your shell profile for persistence).
  2. Run the setup wizard:
       cd "$DEST"
       aios -p "Set up my business"
  3. Optionally schedule cron jobs or install a Discord bot as described in
     the README.

Happy automating!
EOF
