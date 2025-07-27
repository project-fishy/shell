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
        let itemLeft = offsetX + item.x;
        let itemRight = itemLeft + item.width;

        let itemTop = offsetY + item.y;
        let itemBot = itemTop + item.height;

        return itemLeft < pos.x && pos.x < itemRight && itemTop < pos.y && pos.y < itemBot;
    }

    function clamp(num: real, min: real, max: real): real {
        return Math.min(Math.max(num, min), max);
    }
}
