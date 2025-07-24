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
        // print("cached path changed");
        if (hash)
            source = cachedPath; // check if cached image exists
    }

    onStatusChanged: {
        // print("status changed");
        // if it doesnt - make one
        // get orig
        if (source == cachedPath && status == Image.Error) {
            // print("loading orig");
            source = path;
            // save resized
        } else if (source == path && status == Image.Ready) {
            // print("creating cache");
            let p = `/home/desant/fishycache/${hash}`;
            Quickshell.execDetached(["mkdir", "-p", p]);
            root.grabToImage(i => i.saveToFile(cachedPath));
            // source = cachedPath;
        }
        // else if (status == Image.Null)
        //     print(path + " nulled");
        // else if (status == Image.Error)
        //     print(path + " errored");
        // else if (status == Image.Loading)
        //     print(path + " is loading");
    }

    // onProgressChanged: {
    //     print(path + progress);
    // }

    Process {
        id: hashProc

        stdout: StdioCollector {
            onStreamFinished: {
                root.hash = this.text.split(" ")[0];
            }
        }
        stderr: StdioCollector {
            onStreamFinished: {
                print(root.path + " gave this error:\n" + this.text);
            }
        }
    }
}
