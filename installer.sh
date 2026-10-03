#!/usr/bin/env bash
set -e

# Colors for terminal output
CYAN="\033[1;36m"
GREEN="\033[1;32m"
RED="\033[1;31m"
RESET="\033[0m"

echo -e "${CYAN}[+] Setting up Genofetch system...${RESET}"

# Define target paths
INSTALL_DIR="$HOME/.local/bin"
CONFIG_DIR="$HOME/.config/genofetch"

# Create necessary directories
mkdir -p "$INSTALL_DIR"
mkdir -p "$CONFIG_DIR"

# Verify source files exist in the current folder
if [ ! -f "genofetch" ] || [ ! -f "changefsteir" ]; then
    echo -e "${RED}[-] Error: 'genofetch' and 'changefsteir' must be in the current directory!${RESET}"
    exit 1
fi

# Copy files and make them executable
cp genofetch "$INSTALL_DIR/genofetch"
cp changefsteir "$INSTALL_DIR/changefsteir"
chmod +x "$INSTALL_DIR/genofetch"
chmod +x "$INSTALL_DIR/changefsteir"

# Check if ~/.local/bin is inside the user's PATH
case ":$PATH:" in
    *":$INSTALL_DIR:"*) ;;
    *) 
        echo -e "${RED}[!] Warning: $INSTALL_DIR is not currently in your \$PATH.${RESET}"
        echo "    Add 'export PATH=\"\$HOME/.local/bin:\$PATH\"' to your ~/.zshrc or ~/.bashrc file."
        ;;
esac

# Interactive Tier Configuration Prompt during installation
echo -ne "${CYAN}[?] Would you like to configure your hardware specification tier now? [Y/n]: ${RESET}"
read -r response
response=${response:-Y}

if [[ "$response" =~ ^[Yy]$ ]]; then
    # Run the configuration tool directly
    "$INSTALL_DIR/changefsteir"
else
    # Default fallback tier if skipped
    echo "realistic" > "$CONFIG_DIR/tier.conf"
    echo -e "${GREEN}[+] Defaulted configuration to 'realistic' tier.${RESET}"
fi

echo -e "\n${GREEN}[+] Installation successfully completed!${RESET}"
echo "    - Run fetch utility anytime using: genofetch"
echo "    - Modify hardware tiers anytime using: changefsteir"
