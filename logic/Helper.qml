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

        return itemLeft < clickPos.x && clickPos.x < itemRight && itemTop < clickPos.y && clickPos.y < itemBot;
    }

    function msToTime(total: int): string {
        let seconds = total % 60;
        let minutes = (total - seconds) / 60 % 60;
        let hours = ((total - seconds) / 60 - minutes) / 60;

        return (hours > 0 ? `${hours}h ` : "") + `${minutes}m`;
    }

    function clamp(num: real, min: real, max: real): real {
        return Math.min(Math.max(num, min), max);
    }
}
