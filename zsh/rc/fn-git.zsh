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
  command -v delta >/dev/null 2>&1 || return 1

  local -a g=(
    command git
    -c core.pager=delta
    -c interactive.diffFilter='delta --color-only'
  )

  if [[ $# -eq 0 ]]; then
    "$g[@]" diff
  elif git "$1" -h >/dev/null 2>&1; then
    "$g[@]" "$@"
  else
    "$g[@]" diff "$@"
  fi
}
