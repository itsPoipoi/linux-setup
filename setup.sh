# Color
GREEN=$'\e[0;32m'
RED=$'\e[0;31m'
YELLOW=$'\e[0;33m'
NC=$'\e[0m'

# Install Nala for all following installs
sudo apt-get install nala -y
sudo add-apt-repository ppa:neovim-ppa/unstable -y
sudo nala upgrade -y

# Install zsh in case it's not already installed
sudo nala install zsh -y

# Change default shell to zsh
if [ ! "{{$SHELL}}" = "{{/usr/bin/zsh}}" ]; then
  echo "${YELLOW}Change default shell to zsh ?${NC} "
  select yn in "Yes" "No"; do
	  case $yn in
	  	Yes ) chsh -s $(which zsh); break;;
 		  No ) break;;
	  esac
  done
fi

# Import .zshrc
curl -sL https://raw.githubusercontent.com/itsPoipoi/linux-setup/main/.zshrc -o ~/.zshrc
echo "${YELLOW}.zshrc imported.${NC}"

# Install git, trash, neovim, batcat, unzip, fontconfig, etc
sudo nala install git trash-cli neovim bat unzip fontconfig make gcc ripgrep xclip -y

# Install Nerd Font
if [ ! -f ~/.local/share/fonts/FiraCodeNerdFont-Medium.ttf ]; then
	echo "${GREEN}Installing FiraCode Nerd Font...${NC}"
	curl -sL https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/FiraCode.zip --create-dirs -o ~/.local/share/fonts/FiraCode.zip
	unzip -oq ~/.local/share/fonts/FiraCode.zip  -d ~/.local/share/fonts/
	\rm ~/.local/share/fonts/FiraCode.zip
	fc-cache -f ~/.local/share/fonts/
	echo "${RED}Font installed. Remember to select FiraCode font!${NC}"
 	else echo "${GREEN}FiraCode Nerd Font is already installed. Skipping.${NC}"
 fi
 
# Install Homebrew & dependencies
if [ ! -f /home/linuxbrew/.linuxbrew/bin/brew ]; then
  echo "${YELLOW}Installing Homebrew...${NC}"
  NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  else echo "${YELLOW}Homebrew is already installed. Skipping.${NC}"
fi
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# Install fzf
if [ ! -f /home/linuxbrew/.linuxbrew/bin/fzf ]; then
  brew install -q fzf
  else echo "${GREEN}Fzf is already installed. Skipping.${NC}"
fi

# Install eza
if [ ! -f /home/linuxbrew/.linuxbrew/bin/eza ]; then
  brew install -q eza
  else echo "${YELLOW}Eza is already installed. Skipping.${NC}"
fi

# Install zoxide
if [ ! -f ~/.local/bin/zoxide ]; then
  /bin/bash -c "$(curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh)"
  else echo "${GREEN}Zoxide is already installed. Skipping.${NC}"
fi

# Install treesitter
if [ ! -f /home/linuxbrew/.linuxbrew/bin/tree-sitter ]; then
  brew install -q tree-sitter-cli
  else echo "${YELLOW}Treesitter is already installed. Skipping.${NC}"
fi

# Install Fastfetch
if [ ! -f /usr/bin/fastfetch ]; then
  FASTFETCH_URL=$(curl -s https://api.github.com/repos/fastfetch-cli/fastfetch/releases/latest | grep "browser_download_url.*linux-amd64.deb" | cut -d '"' -f 4)
  curl -sL $FASTFETCH_URL -o /tmp/fastfetch_latest_amd64.deb
  sudo nala install /tmp/fastfetch_latest_amd64.deb -y
  else sudo nala install fastfetch -y
fi

# Import Fastfetch config
if [ ! -f ~/.config/fastfetch/config.jsonc ]; then
	fastfetch --gen-config ~/.config/fastfetch/config.jsonc
	curl -sL https://raw.githubusercontent.com/itsPoipoi/linux-setup/main/config.jsonc -o ~/.config/fastfetch/config.jsonc
else
	echo "${GREEN}Fastfetch config already exists. Overwrite it?${NC} "
	select yn in "Yes" "No"; do
		case $yn in
			Yes ) echo "${YELLOW}Overwriting config.${NC}"; curl -sL https://raw.githubusercontent.com/itsPoipoi/linux-setup/main/config.jsonc -o ~/.config/fastfetch/config.jsonc; break;;
 			No ) break;;
		esac
 	done
fi

# Complete message
echo "${GREEN}Setup complete! Profile reloading!${NC}"; zsh
