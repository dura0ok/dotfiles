for f in \
  ~/.fzf.zsh \
  /usr/share/fzf/shell/key-bindings.zsh \
  /usr/share/fzf/key-bindings.zsh \
  /usr/share/doc/fzf/examples/key-bindings.zsh
do
  [[ -f "$f" ]] && source "$f" && break
done

(( ${+widgets[fzf-history-widget]} )) && bindkey '^R' fzf-history-widget
