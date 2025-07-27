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

        model: "content expressive fidelity fruit-salad monochrome neutral rainbow tonal-spot".split(" ")

        Scheme {
            pic: root.path
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
            command: ["sh", "-c", `matugen image ${sc.pic} --dry-run -j hex -t scheme-${sc.modelData} | jq -r '.colors.dark | .primary, .secondary, .tertiary, .background, .on_background'`]

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
