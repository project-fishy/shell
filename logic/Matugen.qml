pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property list<Wallpaper> wallpapers: wallpaperGenerator.instances
    property list<string> rawNames

    property string dirPath: "/home/desant/Pictures/pixiv+/"

    Process {
        id: scraper

        running: true
        command: ["sh", "-c", `ls ${root.dirPath}`]

        stdout: StdioCollector {
            onStreamFinished: {
                root.rawNames = this.text.split("\n").filter(l => l != "");
            }
        }
    }

    Variants {
        id: wallpaperGenerator

        model: Array.from(root.rawNames)

        Wallpaper {}
    }

    FileView {
        id: cacheFile

        watchChanges: true
        path: "/home/desant/fishycache/schemes.json"
    }

    component Wallpaper: QtObject {
        id: wp

        required property string modelData
        readonly property string path: root.dirPath + modelData
        readonly property list<Scheme> schemes: schemeGenerator.instances

        readonly property Variants schemeGenerator: Variants {
            model: "scheme-content scheme-expressive scheme-fidelity scheme-fruit-salad scheme-monochrome scheme-neutral scheme-rainbow scheme-tonal-spot".split(" ")

            Scheme {
                pic: wp.path
            }
        }
    }

    component Scheme: QtObject {
        id: sc
        required property string modelData // theme
        required property string pic

        property string primary
        property string secondary
        property string tertiary
        property string background
        property string foreground

        Component.onCompleted: {
            mat.running = true;
        }

        readonly property Process mat: Process {
            command: ["sh", "-c", `matugen image ${sc.pic} --dry-run -j hex -t ${sc.modelData} | jq -r '.colors.dark | .primary, .secondary, .tertiary, .background, .on_background'`]

            stdout: StdioCollector {
                onStreamFinished: {
                    let lines = this.text.split("\n");

                    sc.primary = lines[0];
                    sc.secondary = lines[1];
                    sc.tertiary = lines[2];
                    sc.background = lines[3];
                    sc.foreground = lines[4];
                }
            }
        }
    }
}
