pragma Singleton

import Quickshell

// random functions
Singleton {

    // flattens a list of lists
    function flatten(nested: list<var>): list<var> {
        return [].concat.apply([], nested);
    }
}
