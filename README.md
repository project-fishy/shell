<h1 align=center>fishy-shell</h1>

> [!CAUTION]
> This is under heavy development and I can't recommend using it yet.
> And even if you still want to, you're on your own figuring out why it's not working. At least for now.

> [!NOTE]
> Proper configs, deps, docs and whatnot coming *Soon™*

## Installation
> [!NOTE]
> You have to be on Hyprland in order for this to work.
> Quickshell supports i3, but i3 doesn't support anything more than a status bar.

Install the deps:
`quickshell-git` `brightnesscli` `cava` `libpipewire` `material-symbols` `monaspace` `MesloLGL Nerd Font`

Clone this repo to `~/.config/quickshell`
```sh
cd $XDG_CONFIG_HOME
git clone https://github.com/project-fishy/shell fishy
```

## Usage
Start detached (allows to close the terminal and can be used in your autostart):
```sh
qs -c fishy -d
```
Hyprland config example:
```sh
# ~/.config/hypr/hyprland.conf
# ...
exec-once qs -c fishy -d
# ...
```
Start attached:
```sh
qs -c fishy
```

## Special thanks
- Caelestia - **heavy** inspiration
- Quickshell - amazing project honestly, lots of fun to work with