# Linux files I want archived for quick linux setup / backup.

Import .zshrc & install dependencies (standalone sh script, Requires curl):
```sh
/bin/bash -c "$(curl -sSfL https://raw.githubusercontent.com/itsPoipoi/linux-setup/main/setup.sh)"
```
Import .zshrc only:
```sh
curl -sL https://raw.githubusercontent.com/itsPoipoi/linux-setup/main/.zshrc -o ~/.zshrc
```
Import Fastfetch Config only (included in setup):
```sh
fastfetch --gen-config
curl -sL https://raw.githubusercontent.com/itsPoipoi/linux-setup/main/config.jsonc -o ~/fastfetch/config.jsonc
```
Install Kanata & import config:
```sh
/bin/bash -c "$(curl -sSfL https://raw.githubusercontent.com/itsPoipoi/linux-setup/refs/heads/main/kanata/kanata-setup.sh)"
```
TO DO :
- Rework repo structure
- Expand setup script / independent scripts
- NeoVim Conf
- Rofi Easy Install & Conf
