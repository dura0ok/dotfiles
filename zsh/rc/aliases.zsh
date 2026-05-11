# Aliases
DISABLE_EZA_ALIASES=0
if (( ${+commands[eza]} )) && [[ ${DISABLE_EZA_ALIASES:-0} != 1 ]]; then
  alias ls='eza --group-directories-first --icons=auto'
  alias ll='eza -l --group-directories-first --icons=auto'
  alias la='eza -la --group-directories-first --icons=auto'
  alias lt='eza --tree --icons=auto'
fi
alias fcd='cd $(find . -type d | fzf)'
alias ve='python3 -m venv .venv'
alias va='source .venv/bin/activate'
alias gd-plain='git --no-pager diff'
# cb: short status, color on, through delta pager
alias cb='git -c color.status=always -c core.pager=delta status -sb'
alias cdpwd='cd "$PWD"'
