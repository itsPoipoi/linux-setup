# Linux files I want archived for quick linux setup / backup.

## Full Install (standalone sh script including every option, Requires curl):

```sh
/bin/bash -c "$(curl -sSfL https://raw.githubusercontent.com/itsPoipoi/linux-setup/main/setup.sh)"
```
Import .zshrc:
```sh
curl -sL https://raw.githubusercontent.com/itsPoipoi/linux-setup/main/.zshrc -o ~/.zshrc
```
Import Fastfetch config:
```sh
fastfetch --gen-config
curl -sL https://raw.githubusercontent.com/itsPoipoi/linux-setup/main/config.jsonc -o ~/fastfetch/config.jsonc
```
Install Kanata & import config:
```sh
/bin/bash -c "$(curl -sSfL https://raw.githubusercontent.com/itsPoipoi/linux-setup/refs/heads/main/kanata/kanata-setup.sh)"
```
Install Rofi & import config:
```sh
/bin/bash -c "$(curl -sSfL https://raw.githubusercontent.com/itsPoipoi/linux-setup/refs/heads/main/rofi/rofi-setup.sh)"
```
Install Alacritty & import config:
```sh
/bin/bash -c "$(curl -sSfL https://raw.githubusercontent.com/itsPoipoi/linux-setup/refs/heads/main/alacritty/setup.sh)"
```

TO DO :
- Rework repo structure
- Expand setup script / independent scripts
- NeoVim Conf
