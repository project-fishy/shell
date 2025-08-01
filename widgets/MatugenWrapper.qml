pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Io

Item {
    id: root

    required property string path
    property list<Scheme> schemes: schemeGenerator.instances

    Variants {
        id: schemeGenerator

        model: "content expressive fidelity fruit-salad monochrome neutral rainbow tonal-spot".split(" ").map(s => [s, root.path])

        Scheme {}
    }

    component Scheme: FileView {
        id: sc

        required property var modelData
        property string scheme: modelData[0] // theme
        property string pic: modelData[1]

        // property bool loaded
        property string hash

        property alias primary: json_adapter.primary
        property alias secondary: json_adapter.secondary
        property alias tertiary: json_adapter.tertiary
        property alias background: json_adapter.background
        property alias foreground: json_adapter.foreground

        path: `/home/desant/fishycache/${sc.hash}/schemes/${sc.scheme}.json`

        onPicChanged: {
            print("pic changed to " + pic);
            hasher.exec(["sha256sum", pic]);
        }

        onPathChanged: {
            if (hash && !loaded)
                mat.running = true;
        }

        JsonAdapter {
            id: json_adapter

            property string primary
            property string secondary
            property string tertiary
            property string background
            property string foreground
        }

        readonly property Process hasher: Process {
            stdout: StdioCollector {
                onStreamFinished: {
                    sc.hash = this.text.split(" ")[0];
                }
            }
        }

        readonly property Process mat: Process {

            command: ["sh", "-c", `matugen image ${sc.pic} --dry-run -j hex -t scheme-${sc.scheme} | jq -r '.colors.dark | .primary, .secondary, .tertiary, .background, .on_background'`]

            stdout: StdioCollector {
                onStreamFinished: {
                    print("generated scheme for " + sc.pic);
                    let lines = this.text.split("\n");

                    sc.primary = lines[0];
                    sc.secondary = lines[1];
                    sc.tertiary = lines[2];
                    sc.background = lines[3];
                    sc.foreground = lines[4];

                    sc.writeAdapter();
                }
            }
        }
    }
}
