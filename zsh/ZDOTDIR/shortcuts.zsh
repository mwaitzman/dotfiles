#this file needs a lot of work

init_el=$HOME/.emacs.d/init.el

alias e="/home/mwait/emacs-ng/src/emacs --debug-init --load $HOME/.emacs.d/init.el"
alias et='/home/mwait/emacs-ng/src/emacs -nw --load /home/mwait/.emacs.d/init.el'

alias ff="/usr/lib/firefox-developer-edition/firefox-bin"

# functions as a drop-in replacement for GNU cat with these settings
alias cat='bat --paging=never'

##I'm used to this from windows, and it's shorter, so...
alias cls='clear'

alias dic=dictionary-cli

alias dotdrop='/home/mwait/devel/other/dotfiles/dotdrop.sh  --cfg=/home/mwait/devel/other/dotfiles/config.yaml'


#get rid of that annoying useless recovery prompt EVERY time I open anything in libreoffice
alias lo=' libreoffice --norestore'


alias atom=atom-dev
alias apm=apm-dev

alias tree=tree-rs


alias evremap='/home/mwait/src/github.com/wez/evremap/target/release/evremap'


devel='/home/mwait/devel/'
alias pcs='cd /home/mwait/devel/my_PCS_work/Homework/'

repos='~/repos'

#relic?
xfce_keybinds='/home/mwait/.config/xfce4/terminal/accels.scm'

alias debtap=$HOME/debtap/debtap

alias firepwd='python /home/mwait/firepwd/firepwd.py'

alias py=python

#powerpill instead of pacman seems broken currently, unless it's not drop-in
alias pacman='sudo pacman -Sy'

alias 'sudo restart now'='sudo reboot now' #because I keep on doing that...

alias textql='docker run --rm -it -v $(pwd):/tmp textql '
## might replace with the actual repo (https://github.com/dinedal/textql, on AUR as textql-git)


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


## based on a meme reddit comment IIRC. Also one character shorter :)
alias plz=sudo

## sudo replacement that can be dropped in for most purposes
alias sudo=doas

##going to use this to smartly edit various files (and run the  appropriate pre/post-edit commands
#function edit() {
#}

alias xa='exa -a'

# enable dual monitor setup for class
function dualmonon() {
	xrandr --output eDP-1 --auto
	xrandr --output DP-1 --primary --left-of eDP-1
}

# return to normal monitor setup
function dualmonoff() {
	xrandr --output eDP-1 --off
}

alias diff='diff -s'

function vol_up() {
pamixer -i 5
pamixer --unmute
}

function vol_down() {
pamixer -d 5
pamixer --unmute
}


#alias fm='pcmanfm'

alias sd="shutdown"

alias sshvps='ssh -i ~/.ssh/id_rsa_VPS root@107.152.41.236'

alias mountvps='plz sshfs -o allow_other,auto_unmount,IdentityFile='/home/mwait/.ssh/id_rsa_VPS' root@107.152.41.236:/ /mnt/vps0/'

###RIIR
##alias wl-copy='wl_copy'
##alias wl-paste='wl-paste'


alias discord="discord-development"


# running this after I login to start the stuff I normally want to start manually, since autostarting wasn't working. need to change that
function startthestuff() {
	setsid -f $(fnott)&
	setsid -f /usr/lib/kdeconnectd&
	setsid -f $(ff)&
	swaymsg reload
	swhks&
	pkexec swhkd
	plz xremap --watch=config ~/.config/xremap/xremap_config.yml
}



##SOURCE: https://unix.stackexchange.com/a/564772
fn_hardlinks() {
  declare target; target="$1" && shift
  [ ! -e "$target" ] && \
    { echo "[error] invalid target: '$target'" 1>&2; exit 1; }
  stat '/' 2>/dev/null 1>&2 || \
    { echo "[error] no functioning 'stat' binary found'" 1>&2; exit 1; }
  declare mount; mount="$(stat -c '%m' "$target")"
  declare inode; inode="$(stat -c '%i' "$target")"
  [ "x${mount[-1]}" != "x/" ] && mount+="/"
  find "$mount" -xdev -inum "$inode" 2>/dev/null
}

alias hardlinks=fn_hardlinks



# find where an alias is defined
fdaliasdef() {
	zsh -ixc : 2>&1 | rg -m 1 "$(alias $1)"
}


# edit an alias in place
editaliasdef() {
         alias_output="$(alias $1)"
         nano +$(zsh -ixc : 2>&1 | rg -m 1 $alias_output | rev | sed 's/$(echo $alias_output | rev)\s>//' | rg -om 1 "\d+" | rev) "$(zsh -ixc : 2>&1 | rg -m 1 $alias_output | rev | sed 's/$(echo $alias_output | rev)//' | rev | sed 's/+//' | rg -om 1 '^[^:]+')"
#	alias_output="$(alias $1)"
#    manip1="$(echo $(zsh -ixc : 2>&1 | rg -m 1 $alias_output | rev)) | sed 's/$(echo $alias_output | rev)//'"
#    compliant_editors=("emacs" "nano" "vi" "nvim")
#    for value in "${compliant_editors[*]}"; do
#      if [ $EDITOR = $VALUE ] then
#        $EDITOR +$(echo $manip1 | sed 's/\s>//' | rg -om 1 "\d+" | rev) $(echo $manip1 | rev | sed 's/+//' | rg -om 1 '^[^:]+')
#        exit 0
#      fi
#    done
#    nano +$(echo $manip1 | sed 's/\s>//' | rg -om 1 "\d+" | rev) $(echo $manip1 | rev | sed 's/+//' | rg -om 1 '^[^:]+')
}


alias gs="git status"


alias extcountlist='find . -type f | grep -i -E -o "\.\w*$" | sort | uniq -c'


# (cargo) cleans the supplied directory (or the current directory if none are specified)
cc() {
	pushd $1
	cargo clean
	popd
}

# make a directory and cd to it
mcd() {
	mkdir $1
	cd $1
}

# I type this manually too often, so..
statwhich() {
	stat $(which $1)
}

tranny() {
if [ "$#" -eq "3" ]; then
	/home/mwait/libretranslate translate $1 $2 $3 |jq '.translatedText' | sed "s/\"/\x1b[38;5;154m/" | rev | sed "s/\"//" | rev
else
	echo "\x1b[31minvalid amount of arguments"
fi
}

alias shadered='SHADERed'

# don't flood my diff output with Cargo.lock's, (but keep it in my git history)
alias gd='git diff -- $(git diff --name-only | grep -Ev "Cargo.lock")'

# Print Duplicate Lines (for source code). Naive, dumb, and very shitty implementation, but it'll suffice until I make a proper program for it
pdl() {
	sort $* | uniq -cd | sort -bn
}
