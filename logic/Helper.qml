pragma Singleton

import Quickshell
import QtQuick

// random functions
Singleton {

    // flattens a list of lists
    function flatten(nested: list<var>): list<var> {
        return [].concat.apply([], nested);
    }

    function checkInBounds(item: Item, pos, offsetX = 0, offsetY = 0) {
        let itemTop = offsetY + item.y;
        let itemBot = itemTop + item.height;

        return itemTop < pos.y && pos.y < itemBot;
    }
}
