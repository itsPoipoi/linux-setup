# Color
GREEN=$'\e[0;32m'
RED=$'\e[0;31m'
YELLOW=$'\e[0;33m'
NC=$'\e[0m'

# Path Exports
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
export HOMEBREW_NO_ANALYTICS=1
export HOMEBREW_NO_ENV_HINTS=1
export PATH=$PATH:"$HOME/.spicetify"
export PATH=$PATH:"$HOME/.local/bin:$HOME/.cargo/bin:/var/lib/flatpak/exports/bin:/.local/share/flatpak/exports/bin"

# Set the directory we want to store zinit and plugins
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Download Zinit, if it's not there yet
if [ ! -d "$ZINIT_HOME" ]; then
   mkdir -p "$(dirname $ZINIT_HOME)"
   git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Source/Load zinit
source "${ZINIT_HOME}/zinit.zsh"

# Add in Powerlevel10k
zinit ice depth=1; zinit light romkatv/powerlevel10k

# Add in zsh plugins
zinit light Aloxaf/fzf-tab
zinit light zdharma-continuum/fast-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light MichaelAquilina/zsh-you-should-use
zinit light fdellwing/zsh-bat

# Add in snippets
zinit snippet OMZP::git
zinit snippet OMZP::sudo
zinit snippet OMZP::command-not-found
zinit snippet OMZP::colored-man-pages

# Load completions
autoload -Uz compinit && compinit

zinit cdreplay -q

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Keybindings
set -o vi
bindkey "^[p" history-search-backward
bindkey "^[n" history-search-forward
bindkey "^[w" kill-region
# bindkey "\e[1;5C" forward-word
# bindkey "\e[1;5D" backward-word
bindkey "\e[3;5~" kill-word
bindkey -s "^f" "zi\n"


if [[ -n $DISPLAY ]]; then
    copy_line_to_x_clipboard() {
        echo -n $BUFFER | xclip -selection clipboard
        zle reset-prompt
    }
    zle -N copy_line_to_x_clipboard
    bindkey '^Y' copy_line_to_x_clipboard
fi

# History
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups
setopt notify

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --group-directories-first --icons --color=always $realpath'
zstyle ':fzf-tab:complete:z:*' fzf-preview 'eza -1 --group-directories-first --icons --color=always $realpath'
zstyle ':fzf-tab:complete:zz:*' fzf-preview 'eza -aD1 --group-directories-first --icons --color=always $realpath'
zstyle ':fzf-tab:complete:zza:*' fzf-preview 'eza -a1 --group-directories-first --icons --color=always $realpath'
zstyle ':fzf-tab:complete:zze:*' fzf-preview 'eza -alh --group-directories-first --icons --color=always $realpath'

# Shell integrations
eval "$(fzf --zsh)"
eval "$(zoxide init zsh)"

#######################################################
# SPECIAL FUNCTIONS
#######################################################

# Editor's
export EDITOR=nvim
export VISUAL=nvim

# Fastfetch on Startup
if [ -f /usr/bin/fastfetch ]; then
	fastfetch
fi

# Extracts any archive(s) (if unp isn't installed)
extract() {
	for archive in "$@"; do
		if [ -f "$archive" ]; then
			case $archive in
			*.tar.bz2) tar xvjf $archive ;;
			*.tar.gz) tar xvzf $archive ;;
			*.bz2) bunzip2 $archive ;;
			*.rar) rar x $archive ;;
			*.gz) gunzip $archive ;;
			*.tar) tar xvf $archive ;;
			*.tbz2) tar xvjf $archive ;;
			*.tgz) tar xvzf $archive ;;
			*.zip) unzip $archive ;;
			*.Z) uncompress $archive ;;
			*.7z) 7z x $archive ;;
			*) echo "don't know how to extract '$archive'..." ;;
			esac
		else
			echo "'$archive' is not a valid file!"
		fi
	done
}

# Searches for text in all files in the current folder
ftext() {
	# -i case-insensitive
	# -H causes filename to be printed
	# -n causes line number to be printed
	rg -iHn --color=always "$1" . | less -r
}

# Copy file with a progress bar
cpp() {
	set -e
	strace -q -ewrite cp -- "${1}" "${2}" 2>&1 |
		awk '{
	count += $NF
	if (count % 10 == 0) {
		percent = count / total_size * 100
		printf "%3d%% [", percent
		for (i=0;i<=percent;i++)
			printf "="
			printf ">"
			for (i=percent;i<100;i++)
				printf " "
				printf "]\r"
			}
		}
	END { print "" }' total_size="$(stat -c '%s' "${1}")" count=0
}

# Copy and go to the directory
cpg() {
	if [ -d "$2" ]; then
		cp "$1" "$2" && cd "$2"
	else
		cp "$1" "$2"
	fi
}

# Move and go to the directory
mvg() {
	if [ -d "$2" ]; then
		mv "$1" "$2" && cd "$2"
	else
		mv "$1" "$2"
	fi
}

# Create and go to the directory
mkdirg() {
	mkdir -p "$1"
	cd "$1"
}

# Goes up a specified number of directories  (i.e. up 4)
up() {
	local d=""
	limit=$1
	for ((i = 1; i <= limit; i++)); do
		d=$d/..
	done
	d=$(echo $d | sed 's/^\///')
	if [ -z "$d" ]; then
		d=..
	fi
	cd $d
}

# Returns the last 2 fields of the working directory
pwdtail() {
	pwd | awk -F/ '{nlast = NF -1;print $nlast"/"$NF}'
}

# IP address lookup
alias whatismyip="whatsmyip"
function whatsmyip ()
{
	# Internal IP Lookup.
	if [ -e /sbin/ip ]; then
		echo -n "Internal IP: "
		/sbin/ip addr show wlan0 | rg "inet " | awk -F: '{print $1}' | awk '{print $2}'
	else
		echo -n "Internal IP: "
		/sbin/ifconfig wlan0 | rg "inet " | awk -F: '{print $1} |' | awk '{print $2}'
	fi

	# External IP Lookup
	echo -n "External IP: "
	curl -s ifconfig.me
}

# Pull this zshrc from Github
pullrc() {
	echo "${GREEN}Pulling .zshrc from Github"
	curl -L https://raw.githubusercontent.com/itsPoipoi/linux-setup/main/.zshrc -o ~/.zshrc
	echo "${YELLOW}RC ready to reload!"
}

# Setup Git PAT
patgit() {
	GREEN=$'\e[0;32m'
	read "PAT? ${GREEN}Input Personal Access Token :"
	git -C ~/linux-setup remote set-url origin https://$(echo $PAT)@github.com/itsPoipoi/linux-setup
	clear
	echo "${GREEN}Terminal cleared for security reasons."
}

# Clone Git repo & setup zshrc symlink
pullgit() {
	git config --global pull.rebase false
	if [ ! -d ~/linux-setup/ ]; then
		git clone https://github.com/itsPoipoi/linux-setup.git
	else 
		git -C ~/linux-setup pull --rebase origin main
	fi
	\rm -f ~/.zshrc
	ln -s linux-setup/.zshrc ~/.zshrc
}

# Push .zshrc to Git repo
pushgit() {
	git config --global user.name "itsPoipoi"
	git config --global user.mail "poipoigit@gmail.com"
	git -C ~/linux-setup add .zshrc
	git -C ~/linux-setup commit -m "..."
	git -C ~/linux-setup push origin main
}

# Run .zshrc setup script from Git
alias psetup='/bin/bash -c "$(curl -sSfL https://raw.githubusercontent.com/itsPoipoi/linux-setup/main/setup.sh)"'

# Nala is always sudo, and lists upgradable on updates
nala () {
	if [[ $@ == "update" ]]; then
		sudo nala update && sudo nala list --upgradable
	else
		sudo nala "$@"
	fi
}

# Automatically do an ls after each zoxide: Only directories
zz ()
{
	if [ -n "$1" ]; then
		__zoxide_z "$@" && eza -aD --icons
	else
		__zoxide_z ~ && eza -aD --icons
	fi
}

# Automatically do an ls after each zoxide: All files
zza ()
{
	if [ -n "$1" ]; then
		__zoxide_z "$@" && eza -a --icons
	else
		__zoxide_z ~ && eza -a --icons
	fi
}

# Automatically do an ls after each zoxide: All files as list
zze ()
{
	if [ -n "$1" ]; then
		__zoxide_z "$@" && eza -alh --icons --group-directories-first
	else
		__zoxide_z ~ && eza -alh --icons --group-directories-first
	fi
}

#######################################################
# GENERAL ALIAS'S
#######################################################
# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#

# To temporarily bypass an alias, we precede the command with a \
# EG: the ls command is aliased, but to use the normal ls command you would type \ls

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Change directory aliases
alias cd..='cd ..'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

# cd into the old directory
alias bd='cd "$OLDPWD"'

# Remove a directory and all files
alias rmd='/bin/rm  --recursive --force --verbose '

# Alias's eza lists
alias ls='eza -a --icons --group-directories-first' 			# add colors, icons, group directories
alias lf='eza -af --icons'  									# files only
alias ld='eza -aD --icons'										# directories only
alias ll='eza -alh --icons --group-directories-first'			# long listing format
alias lfiles='eza -alhf --icons'   								# long format, files only
alias ldirs='eza -alhD --icons'   								# long format, directories only
alias lx='eza -alhfs extension --icons '   						# sort files by extension
alias lk='eza -alhrs size --icons --group-directories-first'		# sort by size
alias lc='eza -alhrs changed --icons --group-directories-first'	# sort by change time
alias la='eza -alhrs accessed --icons --group-directories-first'	# sort by access time
alias lt='eza -alhrs created --icons --group-directories-first'	# sort by date
alias lr='eza -alR --icons --group-directories-first'	# recursive ls

# Alias's for eza trees
alias tree="eza -Ta --icons --group-directories-first"				# Tree all the way, use -L to control depth
alias treemin="eza -Ta --icons -L 2 --group-directories-first"		# Tree into 1 subfolder level
alias treed="eza -TaD --icons"										# Tree directories all the way, use -L to control depth
alias treedmin="eza -TaD --icons -L 2"								# Tree directories into 1 subfolder level							# Tree directories into 1 subfolder level

# Search command line history
alias h="history | rg "

# Search running processes
alias p="ps aux | rg "
alias topcpu="/bin/ps -eo pcpu,pid,user,args | sort -k 1 -r | head -10"

# Search files in the current folder
alias f="find . | rg "

# Count all files (recursively) in the current folder
alias countfiles="for t in files links directories; do echo \`find . -type \${t:0:1} | wc -l\` \$t; done 2> /dev/null"

# Show open ports
alias openports='netstat -nape --inet'

# Alias's to show disk space and space used in a folder
alias diskspace="du -S | sort -n -r |more"
alias folders='du -h --max-depth=1'
alias folderssort='find . -maxdepth 1 -type d -print0 | xargs -0 du -sk | sort -rn'
alias mountedinfo='df -hT'

# Alias's for archives
alias mktar='tar -cvf'
alias mkbz2='tar -cvjf'
alias mkgz='tar -cvzf'
alias untar='tar -xvf'
alias unbz2='tar -xvjf'
alias ungz='tar -xvzf'

# Alias's to modified commands
alias grep="rg"
alias cat="batcat"
alias cp='cp -i'
alias mv='mv -i'
alias rm='trash -v'
alias mkdir='mkdir -p'
alias ping='ping -c 10'
alias less='less -R'
alias apt-get='sudo apt-get'
alias vi='nvim'
alias svi='sudo nvim'
alias vis='nvim "+set si"'
alias curl="curl -#"

# Personal Alias's
alias sht="sudo shutdown -P now"
alias rbt="sudo shutdown -r now"
alias wrbt="sudo grub-reboot 1 && reboot"
alias bios="sudo grub-reboot 2 && reboot"
alias ff="fastfetch"
alias zi="__zoxide_zi"
alias ezrc='nvim ~/.zshrc'
alias evrc='nvim ~/.config/nvim/init.lua'
alias src="source ~/.zshrc"
