// Deduplicate compositor's screen list to one surface set per physical output.
function uniqueByName(screens) {
    var out = [];
    var seen = [];
    var count = screens ? screens.length : 0;
    for (var i = 0; i < count; i++) {
        var s = screens[i];
        if (!s || s.name === "" || !(s.width > 0) || !(s.height > 0))
            continue;
        if (seen.indexOf(s.name) !== -1)
            continue;
        seen.push(s.name);
        out.push(s);
    }
    return out;
}

function sliceForName(instances, name) {
    if (!instances || !name)
        return null;
    for (var i = 0; i < instances.length; i++) {
        var inst = instances[i];
        if (inst && inst.modelData && inst.modelData.name === name)
            return inst;
    }
    return null;
}

function sliceForScreen(instances, screen) {
    return screen ? sliceForName(instances, screen.name) : null;
}

if (typeof module !== "undefined" && module.exports)
    module.exports = { uniqueByName, sliceForName, sliceForScreen };
