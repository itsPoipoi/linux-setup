# Install Deps
sudo nala install cmake g++ pkg-config libfontconfig1-dev libxcb-xfixes0-dev libxkbcommon-dev python3 -y
# Install Cargo
curl https://sh.rustup.rs -sSf | sh
# Install Alacritty
cargo install alacritty
# Import config
curl -sL https://raw.githubusercontent.com/itsPoipoi/linux-setup/refs/heads/main/alacritty/alacritty.toml --create-dirs -o ~/.config/alacritty/alacritty.toml
