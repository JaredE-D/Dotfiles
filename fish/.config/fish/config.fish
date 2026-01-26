if status is-interactive
    # Commands to run in interactive sessions can go here
end

set -x EDITOR nvim
set -x VISUAL "$EDITOR"
set -x SUDO_EDITOR "$EDITOR"
