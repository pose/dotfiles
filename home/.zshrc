# Path to your oh-my-zsh configuration.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
export ZSH_THEME="pose"

# Display red dots whilest waiting for completion
export COMPLETION_WAITING_DOTS="true"

# Disable marking untracked files under VCS as dirty. This makes repository
# status check for large repositories much, much faster.
export DISABLE_UNTRACKED_FILES_DIRTY="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git dirpersist last-working-dir shrink-path zsh-autosuggestions)

# Stash your environment variables in ~/.localrc. This means they'll stay out
# of your main dotfiles repository (which may be public, like this one), but
# you'll have access to them in your scripts.
if [[ -a ~/.localrc ]]
then
  source ~/.localrc
fi

# Needs to happen after so ZSG themes could be customized at ~/.localrc
source $ZSH/oh-my-zsh.sh

# Customize to your needs...

export EDITOR="nvim"
alias vim="nvim"
alias l="ls -lrth"

# TODO Make this into a config.zsh file as in
# https://github.com/holman/dotfiles/blob/master/zsh/config.zsh

setopt NO_BG_NICE # don't nice background tasks
setopt NO_HUP
setopt NO_LIST_BEEP
setopt LOCAL_OPTIONS # allow functions to have local options
setopt LOCAL_TRAPS # allow functions to have local traps
setopt HIST_VERIFY
setopt SHARE_HISTORY # share history between sessions ???
setopt EXTENDED_HISTORY # add timestamps to history
setopt PROMPT_SUBST
setopt CORRECT
setopt COMPLETE_IN_WORD

setopt APPEND_HISTORY # adds history
setopt INC_APPEND_HISTORY_TIME SHARE_HISTORY  # adds history incrementally with timestamps and share it across sessions
setopt HIST_IGNORE_ALL_DUPS  # don't record dupes in history
setopt HIST_REDUCE_BLANKS
# Remove command lines from the history list when the first character on the line is a space,
# or when one of the expanded aliases contains a leading space.
setopt HIST_IGNORE_SPACE

# TODO Do these work?
bindkey '^[^[[D' backward-word
bindkey '^[^[[C' forward-word
bindkey '^[[5D' beginning-of-line
bindkey '^[[5C' end-of-line
bindkey '^[[3~' delete-char
bindkey '^?' backward-delete-char

# TODO Move me out of here into a git config file
# Change default comment character on commits from # to % to allow markdown.
git config --global core.commentchar "%"

# Rebase by default
git config --global pull.rebase true

# Auto-stash by default
git config --global rebase.autostash true

# If on branch X and run git push, default to git push origin X
git config --global --type bool push.autoSetupRemote true

# Globally ignore some files
if [[ ! -e ~/.gitignore_global ]]; then
echo .DS_Store > ~/.gitignore_global
echo mise.local.toml >> ~/.gitignore_global
git config --global core.excludesfile ~/.gitignore_global
fi


# Set Lynx settings
export LYNX_CFG="$HOME/.lynx.cfg"

# Homeshick 👌
source "$HOME/.homesick/repos/homeshick/homeshick.sh"

# Add local user binaries
PATH="$PATH:$HOME/bin:$HOME/.local/bin"

if which fzf &> /dev/null; then
  eval "$(fzf --zsh)"
fi

# Setting rg as the default source for fzf
# rg version of the command (for reference only)
# export FZF_DEFAULT_COMMAND='rg --files --no-ignore --hidden --follow -g "!{.git,node_modules,build,dist}/*" 2> /dev/null'
# ag version
export FZF_DEFAULT_COMMAND='ag --ignore-dir={node_modules,dist,build,.git} -g ""'  #'rg --files --no-ignore --hidden --follow -g "!{.git,node_modules,build,dist,env}/*" 2> /dev/null'

# To apply the command to CTRL-T as well
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

if which mise &> /dev/null; then
  # Activate mise for managing runtimes
  eval "$(mise activate zsh)"
fi

if which npm &> /dev/null; then
  source <(npm completion)
else
  >&2 echo "npm not found. completion disabled."
fi

# Load iterm2 integration (if present)
test -e "$HOME/.iterm2_shell_integration.zsh" && source "$HOME/.iterm2_shell_integration.zsh" || true

# Disable auto title
export DISABLE_AUTO_TITLE="true"

if [[ $TMUX == "" ]]; then
  export TERM="xterm-256color"
else
  # Fixes home and end keys not working on Neovim
  # See: https://github.com/neovim/neovim/issues/6134
  export TERM="screen-256color"
fi

if which atuin &> /dev/null; then
  eval "$(atuin init zsh)"
fi

test -e "$HOME/.cargo/env" && source $HOME/.cargo/env
