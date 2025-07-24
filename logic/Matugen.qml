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
                // print("wallpapers\n" + this.text);
                root.rawNames = this.text.split("\n").filter(l => l != "");
            }
        }
    }

    Variants {
        id: wallpaperGenerator

        // model: ScriptModel {
        //     values: [...root.rawNames]
        // }
        model: Array.from(root.rawNames)

        // Component.onCompleted: print(instances[0].schemes[0].background)

        Wallpaper {}
    }
    FileView {
        watchChanges: true
        path: "/home/desant/fishycache/schemes.json"

        // onFileChanged: reload()
        // onAdapterUpdated: writeAdapter()

        // JsonAdapter {
        //     id: cache_

        //     property list<Json
        // }
    }

    component Wallpaper: QtObject {
        id: wp

        required property string modelData
        readonly property string path: root.dirPath + modelData
        readonly property list<Scheme> schemes: schemeGenerator.instances

        readonly property Variants schemeGenerator: Variants {
            model: "scheme-content scheme-expressive scheme-fidelity scheme-fruit-salad scheme-monochrome scheme-neutral scheme-rainbow scheme-tonal-spot".split(" ")

            // Component.onCompleted: print("created wallpaper " + wp.path)

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
            // print("seeking themes for " + sc.pic);
            // mat.running = true;
            // mat.exec(["matugen", "image", `${sc.pic}`, "--dry-run", "-j", "hex"]);
            // mat.startDetached();
            mat.running = true;
        }

        readonly property Process mat: Process {
            // command: ["matugen", "image", sc.pic, "--dry-run", "-j", "hex"]
            command: ["sh", "-c", `matugen image ${sc.pic} --dry-run -j hex -t ${modelData} | jq -r '.colors.dark | .primary, .secondary, .tertiary, .background, .on_background'`]

            stdout: StdioCollector {
                onStreamFinished: {
                    // print("matugen got\n" + this.text);
                    let lines = this.text.split("\n");
                    // print(`got colors for ${sc.modelData}\n${this.text}`);
                    sc.primary = lines[0];
                    sc.secondary = lines[1];
                    sc.tertiary = lines[2];
                    sc.background = lines[3];
                    sc.foreground = lines[4];
                    // sc.jq.exec(["jq", "-r", ".colors.dark | .primary, .secondary, .tertiary, .background, .on_background", this.text]);
                }
            }

            stderr: StdioCollector {

                onStreamFinished: {}
                // print(sc.mat.command + " " + this.text);
            }
        }

        readonly property Process jq: Process {
            stdout: StdioCollector {
                onStreamFinished: {
                    let lines = this.text.split("\n");
                    // print(`got colors for ${sc.modelData}\n${this.text}`);
                    sc.primary = lines[0];
                    sc.secondary = lines[1];
                    sc.tertiary = lines[2];
                    sc.background = lines[3];
                    sc.foreground = lines[4];
                }
            }

            stderr: StdioCollector {
                onStreamFinished: {
                    print(sc.jq.command + " " + this.text);
                }
            }
        }
    }
}
