alias e="/home/mwait/emacs-ng/src/emacs --debug-init --load $HOME/.emacs.d/init.el"
init_el=$HOME/.emacs.d/init.el

alias ff="/usr/lib/firefox-developer-edition/firefox-bin"
alias cat='bat --paging=never'
alias cls='clear'
alias dic=dictionary-cli
alias dotdrop='/home/mwait/devel/other/dotfiles/dotdrop.sh  --cfg=/home/mwait/devel/other/dotfiles/config.yaml'

alias lo=libreoffice

alias atom=atom-dev
alias apm=apm-dev

alias tree=tree-rs

# Why is it that I can use the $ZSH_CUSTOM alias, but not the $HOME alias??
devel='/home/mwait/devel/'
pcs='/home/mwait/devel/my_PCS_work/Homework/'


zshortcuts='$ZSH_CUSTOM/shortcuts.zsh'
xfce_keybinds='/home/mwait/.config/xfce4/terminal/accels.scm'

alias debtap=$HOME/debtap/debtap

alias firepwd='python /home/mwait/firepwd/firepwd.py'
alias py=python
alias ci='cargo install'
alias pacman='sudo pacman -Sy'

alias 'sudo restart now'='sudo reboot now' #because I keep on doing that...

alias textql='docker run --rm -it -v $(pwd):/tmp textql '
## might replace with the actual repo (https://github.com/dinedal/textql, on AUR as textql-git)

alias et='/home/mwait/emacs-ng/src/emacs -nw --load /home/mwait/.emacs.d/init.el'
###export EDITOR="/usr/local/bin/emacs -nw"

##nice little hack
#alias cd='
#	cd() {
#		z "$1";
#		exa -a;
#	};
#	cd;
#'
## there appears to be a bug causing exa to display the root directory contents instead. not sure why. Are the commands not executed sequentially??
##DISABLED FOR NOW — very broken

# SYNOPSIS
#   quoteRe <text>
quoteRe() { sed -e 's/[^^]/[&]/g; s/\^/\\^/g; $!a\'$'\n''\\n' <<<"$1" | tr -d '\n'; }
##gonna delete this POC later

alias sudo=doas

alias evremap='~/src/github.com/wez/evremap/target/release/evremap'
