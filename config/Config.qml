pragma Singleton

import Quickshell
import Quickshell.Io

import "subconfigs"
import qs.util

Singleton {
    id: root

    property alias theme: adapter.theme
    property alias paths: adapter.paths

    FileView {
        id: fileview
        watchChanges: true
        path: `${Paths.config}/config.json`

        onFileChanged: reload()
        onAdapterUpdated: writeAdapter()
        onLoadFailed: writeAdapter()

        JsonAdapter {
            id: adapter

            property ThemeConfig theme: ThemeConfig {}
            property PathsConfig paths: PathsConfig {}
        }
    }
}
