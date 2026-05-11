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
  local -a g=(command git -c core.pager=delta -c interactive.diffFilter='delta --color-only')
  if [[ $# -eq 0 ]]; then
    if command git diff --quiet && command git diff --cached --quiet; then
      if [[ -n $(command git status --porcelain 2>/dev/null) ]]; then
        print -ru2 '[gitd] no diff on tracked files (untracked ignored). Try: git status | delta'
      fi
    fi
    "$g[@]" diff
  else
    "$g[@]" "$@"
  fi
}
