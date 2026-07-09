#!/usr/bin/env bash

# Default layout for new tmux sessions: nvim on the left, a 40% shell split on
# the right. Invoked by the session-created hook in ~/dotfiles/.tmux.conf via
# run-shell, which sets TMUX_PANE to the new session's pane — all tmux
# commands here rely on that ambient target. (No session argument: hook
# formats like #{hook_session} expand to the session ID "$0", which sh -c
# would then expand to garbage.)
#
# The first session on a freshly started server is skipped when a
# tmux-continuum auto-restore is pending. That session only exists because
# `tmux` was run to boot the server; if this script populated it with extra
# panes, tmux-resurrect would no longer see a single-pane server, so it would
# register the panes as pre-existing and refuse to restore their processes
# (nvim -S, claude -c, ...) — the restored session would come back as empty
# shells.

resurrect_last_save_exists() {
  local dir
  dir="$(tmux show-option -gqv @resurrect-dir)"
  if [ -n "$dir" ]; then
    dir="${dir/#\~/$HOME}"
    [ -f "$dir/last" ]
  else
    [ -f "$HOME/.tmux/resurrect/last" ] || [ -f "$HOME/.local/share/tmux/resurrect/last" ]
  fi
}

auto_restore_pending() {
  [ "$(tmux show-option -gqv @continuum-restore)" = "on" ] || return 1
  [ ! -f "$HOME/tmux_no_auto_restore" ] || return 1
  resurrect_last_save_exists || return 1
  local server_started_at now
  server_started_at="$(tmux display-message -p '#{start_time}')"
  now="$(date +%s)"
  [ $((now - server_started_at)) -lt 15 ]
}

if auto_restore_pending; then
  exit 0
fi

tmux send-keys nvim Enter
new_pane="$(tmux split-window -h -P -F '#{pane_id}' -c '#{pane_current_path}')"
tmux resize-pane -t "$new_pane" -x '40%'
tmux select-pane -t "$TMUX_PANE"
