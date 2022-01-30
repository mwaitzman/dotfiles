##oh-my-zsh relic. TODO: replicate fucntionality
 COMPLETION_WAITING_DOTS="true"


##ohmyzsh relic. TODO: look into functionality and manually setup, then delete these relics
plugins=(
	git
	git-open
	zsh-autosuggestions
	rust
	alias-finder
	aliases
	catimg
	emacs
	cp
	fd
	zoxide
)


## not sure what this is. TODO: investigate
if [ -f /opt/d/d.sh ]; then
  source /opt/d/d.sh
fi



zcfg=$ZDOTDIR/.zshrc
zshortcuts=$ZDOTDIR/shortcuts.zsh

source $HOME/.PRIVATE
source /home/mwait/.config/broot/launcher/bash/br

##TODO: check if this a relic or just not needed
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion


### added by Webi for pyenv#TODO: see what this actually is and delete it
##eval "$(pyenv init -)"
##eval "$(pyenv virtualenv-init -)"

#### RIIR
alias yay=paru
alias wc=cw
alias ping=gping
### /RIIR

### QoL
alias gc='git clone'
alias ci='cargo install'


# Created by `pipx` on 2022-01-10 21:54:33#TODO: not sure if this was actually created by pipx, or it it was just shitty placement. must check and get rid of it if it's unnecessary
export PATH="$PATH:/home/mwait/.local/bin"

##TODO: is this a relic? check and delete if so
##[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# EDITOR was kiro, but eh.. idk if I want to keep it
export EDITOR='nano'
export VISUAL='emacs'

##not sure if this is a relic of ohmyzsh — might delete
fpath=(~/.zsh/functions $fpath)
autoload -Uz compinit
compinit -u

#TODO: check what this actually does
setopt COMBINING_CHARS

## find stuff on my linux partition without scanning other partitions
ffd() {
    fd -E '/mnt' -E '/run/' "$@"
}

## give me case-insensitive tab-completion
autoload -U compinit && compinit
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

##zsh prompt
#TODO: document it entirely
PROMPT='%K{6}%F{236}[%F{91}%h%F{236}]%k %F{57}(%(?.%F{green}√.%F{1}ERR %?)%F{57}%) %B%F{7}|%F{118}%~%F{7}|%b%K{233} %F{14}%# %k'
RPROMPT='%K{90}%F{11}%*%f%k'

## initiate Atuin to handle my zsh history
eval "$(atuin init zsh)"

##initiate Zoxide to handle directory traversal
eval "$(zoxide init zsh)"

##source my zsh shortcuts n' similar
source $zshortcuts

## add realtime syntax highlighting in zsh
##NOTE: **MUST** be at the end of this file
source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
