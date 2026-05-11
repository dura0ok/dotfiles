gch() {
  local branches branch
  branches=$(git branch --all | grep -v HEAD) &&
    branch=$(echo "$branches" | fzf-tmux -d $(( 2 + $(wc -l <<< "$branches") )) +m) &&
    git checkout $(echo "$branch" | sed "s/.* //" | sed "s#remotes/[^/]*/##")
}

fzf-git-status() {
  git rev-parse --git-dir > /dev/null 2>&1 || { echo "Not in a git repo" && return }
  local selected
  selected=$(git -c color.status=always status --short |
    fzf --height 50% --border -m --ansi --nth 2..,.. \
      --preview '(git diff --color=always -- {-1} | sed 1,4d; cat {-1}) | head -500' |
    cut -c4- | sed 's/.* -> //')
  if [[ $selected ]]; then
    for prog in $selected; do $EDITOR "$prog"; done
  fi
}

gitd() {
  command -v delta >/dev/null 2>&1 || { echo 'delta: not on PATH' >&2; return 1 }
  if [[ $# -eq 0 ]]; then
    command git -c core.pager=delta -c interactive.diffFilter='delta --color-only' diff
  else
    command git -c core.pager=delta -c interactive.diffFilter='delta --color-only' "$@"
  fi
}
