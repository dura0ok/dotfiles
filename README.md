# dotfiles

Personal machine bootstrap: [Dotbot](https://github.com/anishathalye/dotbot)

## Quick start

```bash
git clone --recurse-submodules https://github.com/dura0ok/dotfiles ~/.dotfiles
cd ~/.dotfiles
./install
```

## Options

| Flag | Meaning |
|------|--------|
| `./install --skip-apps` | Skip Ghostty, Sublime Text, and VS Code install scripts (links still run). |
| `./install -h` | Show install-wrapper help; anything else (e.g. `-v`, `--only link`) is passed to Dotbot. |
