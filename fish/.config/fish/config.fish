if status is-interactive
    # Commands to run in interactive sessions can go here
end

set -x EDITOR nvim
set -x VISUAL "$EDITOR"
set -x SUDO_EDITOR "$EDITOR"


# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
if test -f /home/Jared/miniconda3/bin/conda
    eval /home/Jared/miniconda3/bin/conda "shell.fish" "hook" $argv | source
else
    if test -f "/home/Jared/miniconda3/etc/fish/conf.d/conda.fish"
        . "/home/Jared/miniconda3/etc/fish/conf.d/conda.fish"
    else
        set -x PATH "/home/Jared/miniconda3/bin" $PATH
    end
end
# <<< conda initialize <<<

export PATH="$HOME/.local/bin:$PATH"
