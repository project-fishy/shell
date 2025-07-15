pragma Singleton

import Quickshell

Singleton {

    function flatten(nested: list<var>): list<var> {
        return [].concat.apply([], nested);
    }
}
