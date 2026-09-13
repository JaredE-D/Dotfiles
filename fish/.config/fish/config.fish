if status is-interactive
    # Commands to run in interactive sessions can go here
end

set -x EDITOR nvim
set -x VISUAL "$EDITOR"
set -x SUDO_EDITOR "$EDITOR"
set -Ux PYENV_ROOT $HOME/.pyenv
set -U fish_user_paths $PYENV_ROOT/bin $fish_user_paths

# Load pyenv automatically by appending
# the following to ~/.config/fish/config.fish:

pyenv init - fish | source
alias nt='alacritty --working-directory (pwd) & disown'

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
if test -f $HOME/miniconda3/bin/conda
    eval $HOME/miniconda3/bin/conda "shell.fish" hook $argv | source
else
    if test -f "$HOME/miniconda3/etc/fish/conf.d/conda.fish"
        . "$HOME/miniconda3/etc/fish/conf.d/conda.fish"
    else
        set -x PATH $HOME/miniconda3/bin $PATH
    end
end
# <<< conda initialize <<<
#

export PATH="$HOME/.local/bin:$PATH"

export PATH="~/.npm-global/bin:$PATH"
