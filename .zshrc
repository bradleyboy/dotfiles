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
export EDITOR="nvim --clean -u ~/.config/nvim/init-lite.lua"
export VISUAL="nvim --clean -u ~/.config/nvim/init-lite.lua"

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

# Automatically switch node version when entering a directory with .nvmrc
if command -v nvm &> /dev/null; then
  autoload -U add-zsh-hook
  load-nvmrc() {
    local nvmrc_path="$(nvm_find_nvmrc)"
    if [ -n "$nvmrc_path" ]; then
      local nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")
      if [ "$nvmrc_node_version" = "N/A" ]; then
        nvm install
      elif [ "$nvmrc_node_version" != "$(nvm version)" ]; then
        nvm use
      fi
    elif [ -n "$(PWD=$OLDPWD nvm_find_nvmrc)" ] && [ "$(nvm version)" != "$(nvm version default)" ]; then
      echo "Reverting to nvm default version"
      nvm use default
    fi
  }
  add-zsh-hook chpwd load-nvmrc
  load-nvmrc
fi

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
  pay remote new "$1" --repo "stripe-internal/mint:bdaily-$1" --region cmh --workspace pay-server --ide none -y --notify-on-ready
  gh-auth-devbox "$1"
  pay remote ssh "$1" --tmux
}

gh-auth-devbox() {
  local name="$1"

  echo "Authenticating GitHub on $name ..."

  pay remote ssh "$name" -- '
    if ! command -v gh >/dev/null 2>&1; then
      sudo apt-get update && sudo apt-get install -y gh
    fi
  '

  local token
  token="$(gh auth token -h git.corp.stripe.com)"
  echo "$token" | pay remote ssh "$name" -- 'gh auth login -p ssh -h git.corp.stripe.com --with-token'

  pay remote ssh "$name" -- 'gh auth status -h git.corp.stripe.com'
  echo "GitHub authentication complete."
}

# Devbox: colored status bar badge for tab differentiation
if [[ "$(uname)" == "Linux" && -n "$box_name" ]]; then
  local _db_colors=('#7dcfff' '#bb9af7' '#9ece6a' '#ff9e64')
  local _db_idx=${DEVBOX_COLOR_IDX:-$(( $(echo -n "$box_name" | cksum | cut -d' ' -f1) % 4 ))}
  local _db_color="${_db_colors[$_db_idx+1]}"

  tmux set-option -g set-titles-string "$box_name / #W"
  local _db_left_len=$(( ${#box_name} + 4 ))
  tmux set-option -g status-left-length "$_db_left_len"
  tmux set-option -g status-left "#[fg=#24283b,bg=${_db_color},bold] ${box_name} #[fg=${_db_color},bg=#24283b] "
fi
