import "../../../../widgets"
import "../../../../config"
import Quickshell.Services.SystemTray
import QtQuick
import Quickshell
import Quickshell.Widgets

// a single tray icon
Item {
    id: root

    required property SystemTrayItem modelData

    implicitWidth: Config.bar.tray.iconSize
    implicitHeight: Config.bar.tray.iconSize

    // the icon
    // stolen from caelestia
    IconImage {
        id: icon

        source: {
            const splitter = "?path=";
            let icon = root.modelData.icon;

            if (icon.includes(splitter)) {
                const [name, path] = icon.split(splitter);
                let cleanName = name.slice(name.lastIndexOf("/") + 1);
                icon = `file://${path}/${cleanName}`;
            }

            return icon;
        }
        asynchronous: true
        anchors.fill: parent
    }
}
