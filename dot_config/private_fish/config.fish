# abbreviations and aliases
alias vim="nvim"
alias ls="eza"
alias la="eza -lah"

# editing my most often used files
alias vimrc="nvim ~/.config/nvim/init.lua"
alias fishrc="nvim ~/.config/fish/config.fish"
abbr --add cmf "nvim (chezmoi managed --include=files --path-style=absolute | fzf)"

abbr --add cm chezmoi
abbr --add cmd "cd ~/.local/share/chezmoi/"
abbr --add cme "nvim (fd . (chezmoi source-path) | fzf)"

set -x EDITOR nvim
set -x VISUAL nvim

function ranger-cd
    set tempfile (mktemp)
    ranger --choosedir=$tempfile
    set ranger_pwd (cat $tempfile)
    if test -d "$ranger_pwd"
        cd "$ranger_pwd"
    end
    rm -f $tempfile
end

alias q="ranger-cd"

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

# zoxide init fish | source

abbr --add g "git"
# if on a feature branch, this shows all commits sense the branching point
abbr --add gdfb "git diff --merge-base"

eval "$(/opt/homebrew/bin/brew shellenv)"


zoxide init fish | source


# bun
set --export BUN_INSTALL "$HOME/.bun"
set --export PATH $BUN_INSTALL/bin $PATH
