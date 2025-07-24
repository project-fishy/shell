pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Io

Item {
    id: root

    property string rawData
    property var papers: paperVariants.instances
    readonly property string picPath: "/home/desant/Pictures/Wallpapers"
    readonly property string cachePath: "/home/desant/fishycache"

    anchors.fill: parent

    states: [
        State {
            name: "wallpapers"
        },
        State {
            name: "themes"
        },
        State {
            name: "done"
        }
    ]

    state: "wallpapers"

    Component.onCompleted: {
        wpGrabber.running = true;
    }

    Process {
        id: wpGrabber

        command: ["sh", "-c", `ls ${root.picPath}`]

        stdout: StdioCollector {
            onStreamFinished: {
                print(this.text);
                root.rawData = this.text;
            }
        }
    }

    Variants {
        id: paperVariants
        model: root.rawData.split("\n")

        Wallpaper {}
    }

    // TODO: this is dirty and stupid
    component Wallpaper: QtObject {
        id: wppl
        required property string modelData

        readonly property string path: `${root.picPath}/${modelData}`
        property string cachedPath

        property string hash

        property string matugenDump
        property string primary
        property string secondary
        property string tertiary

        readonly property Image image: Image {
            asynchronous: true
            cache: false
            fillMode: Image.PreserveAspectCrop
        }
        readonly property Process hashProc: Process {
            property string h
            stdout: StdioCollector {
                onStreamFinished: {
                    wppl.hash = this.text.split(" ")[0];
                    print(wppl.modelData + " got hash " + wppl.hash);
                    wppl.cachedPath = root.cachePath + "/" + wppl.hash + ".png";
                    wppl.image.source = wppl.cachedPath;
                }
            }
        }

        readonly property var c: Connections {
            target: wppl.image

            function onStatusChanged() {
                if (wppl.image.status === Image.Error && wppl.image.source == wppl.cachedPath) {
                    print(wppl.modelData + " has no cache :(");
                    wppl.image.source = wppl.path;
                } else if (wppl.image.status === Image.Ready && wppl.image.source == wppl.path) {
                    print(wppl.modelData + ": creating cache");
                    wppl.image.grabToImage(i => i.saveToFile(wppl.cachedPath));
                    wppl.image.source = wppl.cachedPath;
                } else if (wppl.image.status === Image.Ready && wppl.image.source == wppl.cachedPath)
                    wppl.matugenProc.exec(["matugen", "image", root.picPath, "--dry-run", "-j", "hex"]);
            }
        }

        readonly property Process matugenProc: Process {
            stdout: StdioCollector {
                onStreamFinished: {
                    wppl.matugenDump = this.text;
                }
            }
        }

        onMatugenDumpChanged: {
            if (matugenDump && matugenDump != "")
                parser.running = true;
        }

        readonly property Process parser: Process {
            command: ["jq", "-r", "'.colors.dark' | .primary, .secondary, .tertiary", wppl.matugenDump]
            stdout: StdioCollector {
                onStreamFinished: {
                    print("parser got:\n" + this.text);
                    wppl.primary, wppl.secondary, wppl.tertiary = this.text.split("\n");
                }
            }
        }

        Component.onCompleted: {
            // create cache dir
            hashProc.exec(["sha256sum", path]);
            Quickshell.execDetached(["mkdir", "-p", root.cachePath]);
            // wppl.cachedPath = `${paff}/${wppl.hash}.png`;
            // let the image handle caching
            // wppl.image.source = wppl.cachedPath;
            // grab colors
            // matugenProc.exec(["matugen", "image", root.picPath, "--dry-run", "-j", "hex"]);

            print(modelData + " completed");
        }
    }
}
