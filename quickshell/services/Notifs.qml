pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Services.Notifications

Singleton {
    id: root

    property bool dnd: false
    readonly property int popupDuration: 5000

    property var arrivalMs: ({})
    property var popupExpireAt: ({})

    readonly property var tracked: server.trackedNotifications.values

    readonly property var history: {
        var t = root.tracked;
        var out = [];
        for (var i = 0; i < t.length; i++) {
            var n = t[i];
            if (n.transient || n.expireTimeout === 0)
                continue;
            out.push(n);
        }
        out.sort(function(a, b) { return (root.arrivalMs[b.id] || 0) - (root.arrivalMs[a.id] || 0); });
        return out;
    }

    property var popups: []

    function popupTtl(n) {
        var et = n.expireTimeout;
        if (et === 0) return -1;
        if (et < 0) return root.popupDuration;
        return Math.min(root.popupDuration, et);
    }

    function sameContent(a, b) {
        return (a.appName || "") === (b.appName || "")
            && (a.summary || "") === (b.summary || "")
            && (a.body || "") === (b.body || "");
    }

    function addPopup(n) {
        var list = root.popups.filter(function(p) { return p.id !== n.id && !root.sameContent(p, n); });
        list.unshift(n);
        root.popups = list;
        var ttl = root.popupTtl(n);
        var e = Object.assign({}, root.popupExpireAt);
        if (ttl < 0)
            delete e[n.id];
        else
            e[n.id] = Date.now() + ttl;
        root.popupExpireAt = e;
        schedulePopupReap();
    }

    function removePopup(n) {
        root.popups = root.popups.filter(function(p) { return p !== n; });
        var e = Object.assign({}, root.popupExpireAt);
        delete e[n.id];
        root.popupExpireAt = e;
    }

    function dismiss(n) {
        if (n && typeof n.dismiss === "function")
            n.dismiss();
    }

    function clearAll() {
        var h = root.history.slice();
        for (var i = 0; i < h.length; i++)
            if (typeof h[i].dismiss === "function")
                h[i].dismiss();
    }

    Timer {
        id: popupReaper
        onTriggered: {
            var now = Date.now();
            var e = Object.assign({}, root.popupExpireAt);
            var live = [];
            var release = [];
            for (var i = 0; i < root.popups.length; i++) {
                var p = root.popups[i];
                var due = e[p.id];
                if (due !== undefined && due <= now) {
                    delete e[p.id];
                    if (p.transient && typeof p.expire === "function")
                        release.push(p);
                } else {
                    live.push(p);
                }
            }
            root.popupExpireAt = e;
            if (live.length !== root.popups.length)
                root.popups = live;
            for (var j = 0; j < release.length; j++)
                release[j].expire();
            root.schedulePopupReap();
        }
    }

    function schedulePopupReap() {
        var now = Date.now();
        var soonest = -1;
        for (var id in root.popupExpireAt) {
            var due = root.popupExpireAt[id];
            if (soonest < 0 || due < soonest)
                soonest = due;
        }
        popupReaper.stop();
        if (soonest >= 0) {
            popupReaper.interval = Math.max(1, soonest - now);
            popupReaper.start();
        }
    }

    function hookClosed(n) {
        n.closed.connect(function(reason) {
            root.removePopup(n);
            var a = Object.assign({}, root.arrivalMs);
            delete a[n.id];
            root.arrivalMs = a;
            root.schedulePopupReap();
        });
    }

    NotificationServer {
        id: server
        keepOnReload: true
        bodySupported: true
        actionsSupported: true
        imageSupported: true

        Component.onCompleted: {
            var l = trackedNotifications.values;
            var a = Object.assign({}, root.arrivalMs);
            for (var i = 0; i < l.length; i++) {
                if (!a[l[i].id])
                    a[l[i].id] = Date.now();
                root.hookClosed(l[i]);
            }
            root.arrivalMs = a;
        }

        onNotification: function(n) {
            var a = Object.assign({}, root.arrivalMs);
            a[n.id] = Date.now();
            root.arrivalMs = a;
            n.tracked = true;
            root.hookClosed(n);
            if (!root.dnd)
                root.addPopup(n);
        }
    }
}
