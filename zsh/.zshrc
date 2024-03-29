# Set up the prompt
autoload -Uz promptinit
promptinit
PROMPT='[%(?.%F{green}√.%F{red}?)%f %n@%m %~]$ '

setopt histignorealldups sharehistory

export TERM=xterm-256color

# Use emacs keybindings even if our EDITOR is set to vi
bindkey -e
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word
bindkey '^H' backward-kill-word

alias vim='nvim'

# Set GOPATH
export PATH=$PATH:/usr/local/go/bin
export GOPATH=$HOME/go

export PATH=$PATH:~/.local/bin
HISTSIZE=100000
SAVEHIST=100000
HISTFILE=~/.zsh_history

export PATH=$PATH:~/.tfenv/bin

# Use modern completion system
autoload -Uz compinit
compinit

zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select=2
eval "$(dircolors -b)"
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' menu select=long
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true

zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

if [ -f ~/.local/bin/kubectl ]; then
	source <(kubectl completion zsh);
fi

# Hook for direnv
if [ -f /usr/bin/direnv ]; then
	eval "$(direnv hook zsh)";
fi

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

export PATH="$HOME/.poetry/bin:$PATH"

# opam configuration
[[ ! -r /home/lucasw/.opam/opam-init/init.zsh ]] || source /home/lucasw/.opam/opam-init/init.zsh  > /dev/null 2> /dev/null
