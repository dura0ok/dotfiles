# Media helpers
tomp4() {
  ffmpeg -i "$1" -c:v libx264 -crf 23 -preset medium -c:a aac -b:a 128k "${1%.*}.mp4"
}

cutvid() {
  local infile="$1"
  if [[ -z "$infile" ]]; then
    infile=$(ls | fzf --prompt="Select video: ")
    [[ -z "$infile" ]] && return 1
  fi

  read "start?Start time (hh:mm:ss): "
  read "end?End time (hh:mm:ss): "

  local dir="${infile:h}"
  local base="${infile:t}"
  local outfile="${dir}/cut_${base}"

  ffmpeg -i "$infile" -ss "$start" -to "$end" -c:v libx264 -preset veryfast -crf 23 -c:a aac -b:a 192k "$outfile"

  echo "Saved to $outfile"
}
