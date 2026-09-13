# Dotfiles

Managed with GNU Stow. Each top-level directory mirrors `$HOME`, so
`stow fish hyprland waybar ...` from this repo symlinks the configs into place.

## Post-clone setup

### Hyprland private config (required)

`hyprland/.config/hypr/hyprland.conf` sources `~/.config/hypr/private.conf`,
which is gitignored because it holds personal values (private URLs, etc.).
Hyprland will log a missing-file error until you create it.

Create it with the variables the main config expects:

```
# ~/.config/hypr/private.conf
$notesDoc = https://docs.google.com/document/d/<your-doc-id>/edit
```

Currently used variables:

| Variable    | Used by                               |
|-------------|---------------------------------------|
| `$notesDoc` | `SUPER+SHIFT+J` opens it via xdg-open |

Add any further personal values here rather than in `hyprland.conf`.
