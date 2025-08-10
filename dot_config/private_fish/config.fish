# abbreviations and aliases
alias vim="nvim"
alias q="ranger"
alias ls="eza"

# editing my most often used files
alias vimrc="nvim ~/.config/nvim/init.lua"
alias fishrc="nvim ~/.config/fish/config.fish"
abbr --add cmf "nvim (chezmoi managed --include=files --path-style=absolute | fzf)"

abbr --add cm chezmoi
abbr --add cmd "cd ~/.local/share/chezmoi/"
abbr --add cme "nvim (fd . (chezmoi source-path) | fzf)"

set -x EDITOR nvim
set -x VISUAL nvim

# see: https://asdf-vm.com/guide/getting-started.html
# ASDF configuration code
if test -z $ASDF_DATA_DIR
    set _asdf_shims "$HOME/.asdf/shims"
else
    set _asdf_shims "$ASDF_DATA_DIR/shims"
end

# Do not use fish_add_path (added in Fish 3.2) because it
# potentially changes the order of items in PATH
if not contains $_asdf_shims $PATH
    set -gx --prepend PATH $_asdf_shims
end
set --erase _asdf_shims

# Google Cloud SDK configuration
if test -f /opt/homebrew/share/google-cloud-sdk/path.fish.inc
    source /opt/homebrew/share/google-cloud-sdk/path.fish.inc
end
