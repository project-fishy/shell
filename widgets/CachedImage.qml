import QtQuick
import Quickshell
import Quickshell.Io

Image {
    id: root
    required property string path
    property string cachedPath: `/home/desant/fishycache/${root.hash}/${root.width}x${root.height}.png`

    property string hash

    asynchronous: true
    cache: false
    fillMode: Image.PreserveAspectCrop
    sourceSize.width: width
    sourceSize.height: height

    // get hash see if we have cache
    onPathChanged: {
        hashProc.exec(["sha256sum", path]);
    }

    onCachedPathChanged: {
        if (hash)
            source = cachedPath; // check if cached image exists
    }

    onStatusChanged: {
        // if it doesnt - make one
        // get orig
        if (source == cachedPath && status == Image.Error) {
            source = path;
            // save resized
        } else if (source == path && status == Image.Ready) {
            let p = `/home/desant/fishycache/${hash}`;
            Quickshell.execDetached(["mkdir", "-p", p]);
            root.grabToImage(i => i.saveToFile(cachedPath));
            // can't switch to cached, it breaks
        }
    }

    Process {
        id: hashProc

        stdout: StdioCollector {
            onStreamFinished: {
                root.hash = this.text.split(" ")[0];
            }
        }
    }
}
