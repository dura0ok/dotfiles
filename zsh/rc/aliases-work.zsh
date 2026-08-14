alias mco='meson compile -C buildDir'
alias mt='meson test -C buildDir'

mr() {
  rm -rf buildDir
  meson setup buildDir
}

mreset() {
  mr && mco
}

pt()  { py.test -l -v -s -n 12 "$@" }
ptx() { py.test -l -v -s -x -n 12 "$@" }
pts() { py.test -l -v -s "$@" }
