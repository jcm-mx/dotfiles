# Development environment setup

A reproducible terminal-native development environment across Fedora (home) and Ubuntu (work).

| Machine | OS |
|---|---|
| Home desktop + laptop | Fedora (GNOME) |
| Work machine | Ubuntu (GNOME) |

---

## Stack overview

| Tool | Purpose |
|---|---|
| Neovim + LazyVim | Editor |
| GitHub Copilot | AI completion and review |
| tmux | Terminal multiplexer |
| zsh + vi mode | Shell |
| lazygit | Git TUI |
| fzf | Fuzzy finder |
| zoxide | Smart cd replacement |
| GNU Stow | Dotfiles symlink management |
| git | Dotfiles version control |

---

## Dotfiles repo structure

All configuration lives in a single git repo. GNU Stow manages symlinks from the repo into `$HOME`. A wrapper script handles target and directory flags explicitly so the repo can live anywhere on the filesystem.

```
<repo>/
├── nvim/
│   └── .config/
│       └── nvim/           # symlinked to ~/.config/nvim
│           ├── init.lua
│           └── lua/
│               └── plugins/
├── tmux/
│   └── .config/
│       └── tmux/           # symlinked to ~/.config/tmux
│           └── tmux.conf
├── zsh/
│   └── .zshrc              # symlinked to ~/.zshrc
├── git/
│   └── .config/
│       └── git/            # symlinked to ~/.config/git
│           └── config
├── personal/
│   └── LEARNING.md         # learning path tracker — not stowed
├── stow.sh                 # stow wrapper script
└── README.md
```

All configs follow XDG conventions and live under `.config/` where the tool supports it. Tmux supports `~/.config/tmux/tmux.conf` natively since version 3.1.

### stow.sh wrapper

```bash
#!/bin/bash
# Works regardless of where the repo lives on the filesystem.
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

stow --target="$HOME" --dir="$DOTFILES_DIR" "$@"
```

Make it executable:

```bash
chmod +x stow.sh
```

### Initial setup on a new machine

```bash
# Clone the repo — can be anywhere on the filesystem
git clone git@github.com:<username>/dotfiles.git ~/dotfiles

# Stow each config
~/dotfiles/stow.sh nvim
~/dotfiles/stow.sh tmux
~/dotfiles/stow.sh zsh
~/dotfiles/stow.sh git

# Or stow everything at once
~/dotfiles/stow.sh nvim tmux zsh git
```

### Adding a new config to the repo

```bash
# Move the existing config into the dotfiles repo
mv ~/.config/nvim ~/dotfiles/nvim/.config/nvim

# Stow it — creates the symlink
~/dotfiles/stow.sh nvim
```

### Re-stowing after changes

```bash
~/dotfiles/stow.sh --restow nvim
```

---

## Machine-specific config

Anything that differs between Fedora and Ubuntu lives in a local file that is not tracked in git.

Add this to the bottom of `.zshrc`:

```zsh
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local
```

Use `~/.zshrc.local` on each machine for OS-specific aliases, paths, or environment variables.

---

## Installation

### Fedora

```bash
# Neovim — use unstable PPA or GitHub release for latest version
# Option A: GitHub release binary (recommended — always latest)
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
tar -xzf nvim-linux-x86_64.tar.gz
sudo mv nvim-linux-x86_64 /opt/nvim
echo 'export PATH="$PATH:/opt/nvim/bin"' >> ~/.zshrc.local

# Core tools
sudo dnf install git zsh tmux fzf stow

# lazygit
sudo dnf copr enable atim/lazygit
sudo dnf install lazygit

# zoxide
curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh

# Node.js (required for Copilot)
sudo dnf install nodejs
```

### Ubuntu

```bash
# Neovim — distro version is often outdated, use GitHub release binary
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
tar -xzf nvim-linux-x86_64.tar.gz
sudo mv nvim-linux-x86_64 /opt/nvim
echo 'export PATH="$PATH:/opt/nvim/bin"' >> ~/.zshrc.local

# Core tools
sudo apt install git zsh tmux fzf stow

# lazygit
LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep tag_name | cut -d '"' -f 4)
curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION#v}_Linux_x86_64.tar.gz"
tar xf lazygit.tar.gz lazygit
sudo install lazygit -D -t /usr/local/bin/

# zoxide
curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh

# Node.js (required for Copilot)
sudo apt install nodejs npm
```

---

## Neovim — LazyVim

### Install LazyVim

```bash
# Back up existing config if any
mv ~/.config/nvim ~/.config/nvim.bak

# Clone LazyVim starter
git clone https://github.com/LazyVim/starter ~/.config/nvim
rm -rf ~/.config/nvim/.git
```

Then move the config into your dotfiles repo and stow it:

```bash
mv ~/.config/nvim ~/dotfiles/nvim/.config/nvim
~/dotfiles/stow.sh nvim
```

### GitHub Copilot

Add to `~/dotfiles/nvim/.config/nvim/lua/plugins/copilot.lua`:

```lua
return {
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("copilot").setup({
        suggestion = { enabled = false },
        panel = { enabled = false },
      })
    end,
  },
  {
    "zbirenbaum/copilot-cmp",
    config = function()
      require("copilot_cmp").setup()
    end,
  },
}
```

Authenticate after first launch:

```
:Copilot auth
```

### lazygit integration

LazyVim includes lazygit out of the box. Open it with `<leader>gg`.

### Key LazyVim keybindings

| Keybinding | Action |
|---|---|
| `<leader>gg` | Open lazygit |
| `<leader>ff` | Find files (Telescope) |
| `<leader>fg` | Live grep |
| `<leader>e` | Toggle file explorer |
| `<C-h/j/k/l>` | Navigate splits |
| `<leader>?` | Show all keybindings (which-key) |

---

## zsh configuration

### Base `.zshrc`

```zsh
# Vi mode
bindkey -v
KEYTIMEOUT=1

# fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# zoxide — replaces cd
eval "$(zoxide init zsh)"

# Aliases
alias vim="nvim"
alias vi="nvim"
alias lg="lazygit"
alias ls="ls --color=auto"

# Machine-specific overrides
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local
```

### Vi mode cursor shape

Add to `.zshrc` to show cursor shape change on mode switch:

```zsh
function zle-keymap-select {
  if [[ ${KEYMAP} == vicmd ]]; then
    echo -ne '\e[1 q'   # block cursor — normal mode
  else
    echo -ne '\e[5 q'   # beam cursor — insert mode
  fi
}
zle -N zle-keymap-select
```

---

## tmux configuration

Config lives at `~/.config/tmux/tmux.conf` (XDG path, supported since tmux 3.1).

Base `tmux.conf`:

```bash
# Prefix — remap to Ctrl+a (more ergonomic than Ctrl+b)
unbind C-b
set -g prefix C-a
bind C-a send-prefix

# Split panes with | and -
bind | split-window -h
bind - split-window -v

# Vim-style pane navigation
bind h select-pane -L
bind j select-pane -D
bind k select-pane -U
bind l select-pane -R

# Enable mouse
set -g mouse on

# True color support
set -g default-terminal "tmux-256color"
set -ag terminal-overrides ",*:RGB"

# Start windows and panes at 1
set -g base-index 1
setw -g pane-base-index 1

# Reduce escape delay (important for Neovim)
set -sg escape-time 10
```

### vim-tmux-navigator

Install the plugin via TPM and add to `.tmux.conf`:

```bash
# TPM plugin manager
set -g @plugin 'tmux-plugins/tpm'
set -g @plugin 'christoomey/vim-tmux-navigator'

run '~/.tmux/plugins/tpm/tpm'
```

This allows `<C-h/j/k/l>` to move between both tmux panes and Neovim splits seamlessly.

Install TPM:

```bash
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

Then inside tmux press `prefix + I` to install plugins.

---

## External dependencies

These are required by LazyVim plugins and should be installed on all machines:

```bash
# Fedora
sudo dnf install ripgrep fd-find gcc

# Ubuntu
sudo apt install ripgrep fd-find gcc
```

---

## First-time setup checklist

- [ ] Install Neovim (GitHub release binary)
- [ ] Install core tools — zsh, tmux, fzf, stow, lazygit, zoxide, nodejs
- [ ] Install external dependencies — ripgrep, fd, gcc
- [ ] Clone dotfiles repo (anywhere on the filesystem)
- [ ] Run `stow.sh` for each config package
- [ ] Create `~/.zshrc.local` with machine-specific settings
- [ ] Change default shell to zsh — `chsh -s $(which zsh)`
- [ ] Launch Neovim — LazyVim will auto-install plugins on first run
- [ ] Run `:Copilot auth` to authenticate GitHub Copilot
- [ ] Install TPM and tmux plugins — `prefix + I` inside tmux
- [ ] Verify lazygit opens with `<leader>gg` in Neovim

---

## Maintenance

- **Updating plugins:** Run `:Lazy update` inside Neovim
- **Updating LazyVim itself:** Run `:LazyVim update`
- **Adding a new tool config:** Add to dotfiles repo, run `stow.sh`, commit
- **Syncing between machines:** `git pull` in dotfiles repo, run `stow.sh --restow <package>` if structure changed
