# Git worktrees (wt, branchlet)
if command -v wt >/dev/null 2>&1; then
  eval "$(command wt config shell init zsh)"
fi

_branchlet() {
  local -a commands
  commands=(
    'create:Create a new worktree'
    'list:List all worktrees'
    'delete:Delete a worktree'
    'settings:Manage configuration'
  )
  _arguments -C \
    '(-h --help)'{-h,--help}'[Show help]' \
    '(-v --version)'{-v,--version}'[Show version]' \
    '(-m --mode)'{-m,--mode}'[Set mode]:mode:(menu create list delete settings)' \
    '--from-wrapper[Called from shell wrapper]' \
    '1:command:->command'
  case "$state" in
    command)
      _describe -t commands 'branchlet commands' commands
      ;;
  esac
}
compdef _branchlet branchlet

branchlet() {
  if [ $# -eq 0 ]; then
    local dir=$(FORCE_COLOR=3 command branchlet --from-wrapper)
    if [ -n "$dir" ]; then
      builtin cd "$dir" && echo "Branchlet: Navigated to $(pwd)"
    fi
  else
    command branchlet "$@"
  fi
}
