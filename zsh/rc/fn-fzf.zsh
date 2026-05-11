fzf-env-vars() {
  local out
  out=$(env | fzf)
  echo $(echo $out | cut -d= -f2)
}

fzf-kill-processes() {
  local pid
  pid=$(ps -ef | sed 1d | fzf -m | awk '{print $2}')
  if [ -n "$pid" ]; then
    echo $pid | xargs kill -${1:-9}
  fi
}

fzf-find-files() {
  local file=$(fzf --multi --reverse)
  if [[ $file ]]; then
    for prog in $file; do $EDITOR "$prog"; done
  else
    echo "Cancelled"
  fi
}
