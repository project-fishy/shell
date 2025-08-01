pragma Singleton
pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Io
import QtQuick

// numbers regarding element placement
Singleton {
    readonly property Bar bar: Bar {}
    readonly property Panel panel: Panel {}
    readonly property Spacings spacing: Spacings {}
    readonly property Radii radius: Radii {}
    readonly property Slider slider: Slider {}
    readonly property Toasts toast: Toasts {}
    property alias workspaces: json_adapter.workspaces
    property alias saved: config_adapter

    component Toasts: QtObject {
        property int size: 35
        property int protrusions: 20

        readonly property string state_hidden: "hidden"
        readonly property string state_peek: "peek"
        readonly property string state_shown: "shown"

        readonly property int right: 0
        readonly property int left: 1
        readonly property int top: 2
        readonly property int bottom: 3
    }

    component Spacings: QtObject {
        readonly property int smaller: 3
        readonly property int small: 5
        readonly property int normal: 10
        readonly property int large: 15
    }

    component Radii: QtObject {
        readonly property int smaller: 3
        readonly property int small: 5
        readonly property int normal: 10
        readonly property int large: 15
        readonly property int larger: 20
    }

    component Slider: QtObject {
        readonly property int thickness: 25
    }

    component Bar: QtObject {
        property int width: 40
        property int workspaces: 5
        property int margins: 10

        readonly property Tray tray: Tray {}
    }

    component Tray: QtObject {
        property int iconSize: 20
        property int spacing: 5
    }

    component Panel: QtObject {
        readonly property int right: 0
        readonly property int left: 1
        readonly property int top: 2
        readonly property int bottom: 3
        readonly property int outline: 1
    }

    FileView {
        watchChanges: true
        path: "/home/desant/.config/fishy/config.json"

        onFileChanged: reload()
        onAdapterUpdated: writeAdapter()

        onLoadFailed: writeAdapter()

        JsonAdapter {
            id: config_adapter

            property string wallpaper: "/home/desant/Pictures/Wallpapers/blue_pain.jpg"
            property string scheme: "content"
        }
    }

    Connections {
        target: config_adapter

        function onWallpaperChanged() {
            Quickshell.execDetached(["matugen", "image", "-t", `scheme-${saved.scheme}`, saved.wallpaper]);
        }

        function onSchemeChanged() {
            Quickshell.execDetached(["matugen", "image", "-t", `scheme-${saved.scheme}`, saved.wallpaper]);
        }
    }

    FileView {
        watchChanges: true
        path: "/home/desant/.config/fishy/workspaces.json"

        onFileChanged: reload()
        onAdapterUpdated: writeAdapter()

        onLoadFailed: writeAdapter()

        JsonAdapter {
            id: json_adapter

            property list<JsonObject> workspaces: [
                JsonObject {
                    property string name: "1"
                    property string monitor: "eDP-1"
                    property string indicator: "一"
                },
                // 一二三四五六七八九十
                JsonObject {
                    property string name: "2"
                    property string monitor: "eDP-1"
                    property string indicator: "二"
                },
                JsonObject {
                    property string name: "3"
                    property string monitor: "eDP-1"
                    property string indicator: "三"
                },
                JsonObject {
                    property string name: "4"
                    property string monitor: "eDP-1"
                    property string indicator: "四"
                },
                JsonObject {
                    property string name: "5"
                    property string monitor: "eDP-1"
                    property string indicator: "五"
                },
                JsonObject {
                    property string name: "6"
                    property string monitor: "DP-1"
                    property string indicator: "六"
                },
                JsonObject {
                    property string name: "7"
                    property string monitor: "DP-1"
                    property string indicator: "七"
                },
                JsonObject {
                    property string name: "8"
                    property string monitor: "DP-1"
                    property string indicator: "八"
                },
                JsonObject {
                    property string name: "9"
                    property string monitor: "DP-1"
                    property string indicator: "九"
                },
                JsonObject {
                    property string name: "10"
                    property string monitor: "DP-1"
                    property string indicator: "十"
                }
            ]
        }
    }
}
