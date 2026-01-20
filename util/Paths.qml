pragma Singleton

import Quickshell

import qs.config

// heavy inspo from Caelestia
Singleton {
    readonly property string home: Quickshell.env("HOME")

    readonly property string data: `${Quickshell.env("XDG_DATA_HOME") || `${home}/.local/share`}/fishy`
    readonly property string state: `${Quickshell.env("XDG_STATE_HOME") || `${home}/.local/state`}/fishy`
    readonly property string cache: `${Quickshell.env("XDG_CACHE_HOME") || `${home}/.cache`}/fishy`
    readonly property string config: `${Quickshell.env("XDG_CONFIG_HOME") || `${home}/.config`}/fishy`

    readonly property string pictures: `${home}/Pictures`
    readonly property string wallpapers: Config.paths.wallpapers
    readonly property string imageCache: `${cache}/imagecache`
}
