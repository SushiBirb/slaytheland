pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Services.UPower

Singleton {
    id: root

    readonly property var dev: UPower.displayDevice

    readonly property var batDev: {
        var list = UPower.devices ? UPower.devices.values : [];
        for (var i = 0; i < list.length; i++) {
            if (list[i] && list[i].isLaptopBattery && list[i].isPresent)
                return list[i];
        }
        return dev;
    }

    readonly property bool present: batDev !== null && batDev.isLaptopBattery && batDev.isPresent
    readonly property real frac: batDev ? Math.max(0, Math.min(1, batDev.percentage)) : 1.0
    readonly property int pct: Math.round(frac * 100)
    readonly property int state: batDev ? batDev.state : UPowerDeviceState.Unknown

    readonly property bool charging: state === UPowerDeviceState.Charging
    readonly property bool full: state === UPowerDeviceState.FullyCharged || pct >= 100
    readonly property bool discharging: state === UPowerDeviceState.Discharging
    readonly property bool low: !charging && pct <= 20
    readonly property bool critical: !charging && pct <= 10

    readonly property bool onAc: !UPower.onBattery

    readonly property string stateLabel: charging ? "Charging"
        : (full ? "On AC · Full"
        : (discharging ? "Discharging" : "On AC"))

    function fmt(sec) {
        var s = Math.max(0, Math.round(sec));
        var h = Math.floor(s / 3600);
        var m = Math.floor((s % 3600) / 60);
        if (h > 0)
            return h + "h " + m + "m";
        return m + "m";
    }

    readonly property string timeStr: !batDev ? ""
        : (charging ? fmt(batDev.timeToFull) : (discharging ? fmt(batDev.timeToEmpty) : ""))
}
