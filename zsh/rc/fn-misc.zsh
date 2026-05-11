load_env_file() {
  local file="$1"

  if [[ ! -f "$file" ]]; then
    echo "File not found: $file"
    return 1
  fi

  while IFS= read -r line; do
    # trim leading/trailing whitespace
    line="$(echo "$line" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')"

    # skip empty and comments
    [[ -z "$line" || "$line" =~ ^# ]] && continue

    # only VAR=VALUE lines
    if [[ "$line" =~ ^[A-Za-z_][A-Za-z0-9_]*= ]]; then
      export "$line"
    fi
  done < "$file"
}
