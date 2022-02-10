# My configuration files for various things, as well as some useful scripts.
Currently a hot mess — will be cleaned up later

# TODO: 
* auto-commit files hardlinked in bash script
Store original file locations in a database or something.
Ensure they're actually up to date (I thought hardlinks were always up to date, but a `bat`on the hardlink displayed the non-updated contents, so...)

# Wayland configuration
[River](https://github.com/riverwm/river) will be used for now as a Wayland compositor.  
[Onagre](https://github.com/oknozor/onagre) is used as a launcher  
[waylock](https://github.com/ifreund/waylock) will be used as a screenlocker.  
[i3status-rs](https://github.com/greshake/i3status-rust) will be used a status bar.  

# keybindings
Using Crontab with the included crontab file, [evremap](https://github.com/wez/evremap) is run on boot with the GLOBAL_KEYMAP.toml file, to set keyboard settings that apply to *everything* v both the Linux Virtual Console, Wayland sessions, and X11 sessions.
Then, [xremap](https://github.com/k0kubun/xremap) will be used in Wayland for application-specific key combination or key sequence remappings, while [swhkd](https://github.com/waycrate/swhkd) will be used to launch commands via keybinds (e.g. s-R to launch Onagre).


Espanso is used as a text expander
