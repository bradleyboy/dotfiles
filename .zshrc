# Download and start Znap to manage plugins
[[ -f ~/Git/zsh-snap/znap.zsh ]] ||
    git clone --depth 1 -- \
        https://github.com/marlonrichert/zsh-snap.git ~/Git/zsh-snap

source ~/Git/zsh-snap/znap.zsh

COMPLETION_WAITING_DOTS="true"

# Important for .fzf/bin to be before homebrew so we get the fzf
# that the plugins below install.
export PATH="$PATH:$HOME/.fzf/bin:$HOME/.rvm/bin:$HOME/.deno/bin:$HOME/.cargo/bin:$HOME/bin:$HOME/.local/bin"
[[ "$(uname)" == "Darwin" ]] && export PATH="$PATH:/opt/homebrew/bin"
[[ "$(uname)" == "Linux" ]] && export PATH="$PATH:$HOME/.npm-global/bin"
export EDITOR="nvim"
export VISUAL="nvim"

bindkey -v
autoload edit-command-line; zle -N edit-command-line
bindkey -M vicmd v edit-command-line

# Load Stripe shellinit early so Pure prompt overrides its default PROMPT
if [[ -f ~/.stripe/shellinit/zshrc ]]; then
  source ~/.stripe/shellinit/zshrc
fi

# pure prompt
fpath+=($HOME/.zsh/pure)
autoload -Uz promptinit; promptinit
PURE_PROMPT_SYMBOL="→"
PURE_GIT_PULL=0
# color tweaks to match tokyonight a bit more
zstyle :prompt:pure:git:branch color '#a9b1d6'
zstyle :prompt:pure:git:branch:cached color '#a9b1d6'
zstyle :prompt:pure:git:dirty color '#c7a9ff'
prompt pure

# plugins
znap source ohmyzsh/ohmyzsh plugins/git
znap source zsh-users/zsh-autosuggestions
znap source zsh-users/zsh-syntax-highlighting
znap source zsh-users/zsh-history-substring-search
znap source unixorn/fzf-zsh-plugin

# User configuration
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

alias ..='cd ..'
alias ...='cd ../..'
alias rp='git pull --rebase'
alias amend='git commit -a --amend'
alias hgist='git show HEAD | gist -t diff'
alias dgist='git diff | gist -t diff'
alias hfiles='git diff-tree --no-commit-id --name-only -r HEAD'
alias rem='git co main && git rpull && git co - && git rebase -'
alias rbs="git for-each-ref --sort=-committerdate refs/heads/ --format='%(HEAD) %(color:yellow)%(refname:short)%(color:reset) - %(color:red)%(objectname:short)%(color:reset) - %(color:cyan)%(authorname)%(color:reset) (%(color:green)%(committerdate:relative)%(color:reset))'"
alias hstat="git show HEAD --stat"
alias dstat="git diff --stat"
alias pods="kubectl get pods"
alias vim="nvim"
alias co="git branch --sort=-committerdate | grep -v \"^\*\" | fzf --height=30% --reverse --info=inline | xargs git checkout"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
[ -f ~/.aliases ] && source ~/.aliases

if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi

if [ -f "/opt/homebrew/etc/profile.d/z.sh" ]; then . "/opt/homebrew/etc/profile.d/z.sh"; fi

# The next line updates PATH for the Google Cloud SDK.
if [ -f "$HOME/google-cloud-sdk/path.zsh.inc" ]; then . "$HOME/google-cloud-sdk/path.zsh.inc"; fi

# The next line enables shell command completion for gcloud.
if [ -f "$HOME/google-cloud-sdk/completion.zsh.inc" ]; then . "$HOME/google-cloud-sdk/completion.zsh.inc"; fi

# bun
if [[ -d "$HOME/.bun" ]]; then
  [ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"
  export BUN_INSTALL="$HOME/.bun"
  export PATH="$BUN_INSTALL/bin:$PATH"
fi

export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS \
  --highlight-line \
  --info=inline-right \
  --ansi \
  --layout=reverse \
  --border=none \
  --color=bg+:#2e3c64 \
  --color=bg:#1f2335 \
  --color=border:#29a4bd \
  --color=fg:#c0caf5 \
  --color=gutter:#1f2335 \
  --color=header:#ff9e64 \
  --color=hl+:#2ac3de \
  --color=hl:#2ac3de \
  --color=info:#545c7e \
  --color=marker:#ff007c \
  --color=pointer:#ff007c \
  --color=prompt:#2ac3de \
  --color=query:#c0caf5:regular \
  --color=scrollbar:#29a4bd \
  --color=separator:#ff9e64 \
  --color=spinner:#ff007c \
"

[ -f "$HOME/.local/share/../bin/env" ] && . "$HOME/.local/share/../bin/env"

devbox() {
  if [[ -z "$1" ]]; then
    echo "Usage: devbox <name>"
    return 1
  fi
  pay remote new "$1" --repo "stripe-internal/mint:bdaily-$1" --workspace pay-server --ide none -y --notify-on-ready --ssh --tmux
}

# If devbox name exists, use it in the title
if [[ "$(uname)" == "Linux" && -n "$box_name" ]]; then
  tmux set-option -g set-titles-string "$box_name / #W"
fi
