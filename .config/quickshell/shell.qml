import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Hyprland
import Quickshell.Services.Pipewire
import Quickshell.Services.Notifications
import Quickshell.Widgets
import Quickshell.DBusMenu
import "LiveStat.qml"
import "NotifService.qml"
import Quickshell.Bluetooth
import Quickshell.Services.SystemTray
import Quickshell.Services.Mpris
import QtQuick.Controls


ShellRoot {
    id: shellRoot

    PwObjectTracker {
        objects: [Pipewire.defaultAudioSink]
    }


    // sample for bluetooth, mpris, and system tray
    // 
    // PanelWindow {
    //     id: root
    //
    //     // Theme
    //     property color colBg: "#1a1b26"
    //     property color colFg: "#a9b1d6"
    //     property color colMuted: "#444b6a"
    //     property color colCyan: "#0db9d7"
    //     property color colBlue: "#7aa2f7"
    //     property color colYellow: "#e0af68"
    //     property string fontFamily: "JetBrainsMono Nerd Font"
    //     property int fontSize: 14
    //
    //     // System data
    //     property int cpuUsage: 0
    //     property int memUsage: 0
    //     property var lastCpuIdle: 0
    //     property var lastCpuTotal: 0
    //
    //     // Processes and timers here...
    //
    //     anchors.top: true
    //     anchors.left: true
    //     anchors.right: true
    //     implicitHeight: 30
    //     color: root.colBg
    //
    //     RowLayout {
    //         anchors.fill: parent
    //         anchors.margins: 8
    //         spacing: 8
    //
    //         Repeater {
    //             model: Bluetooth.devices
    //             Text {
    //                 required property var modelData
    //
    //                 text: modelData.name
    //             }
    //         }
    //         Repeater {
    //             model: Bluetooth.adapters
    //             Text {
    //                 required property var modelData
    //
    //                 text: modelData.name + " " + modelData.enabled + " " + modelData.pairable
    //             }
    //         }
    //         Repeater {
    //             model: Mpris.players
    //             Text {
    //                 required property var modelData
    //
    //                 text: "what " + modelData.trackArtist + " " + modelData.desktopEntry
    //             }
    //         }
    //         Repeater {
    //             model: SystemTray.items
    //             Text {
    //
    //                 text: "zzz " + modelData.id + " " + modelData.hasMenu + " " + modelData.tooltipDescription
    //                 MouseArea {
    //                     anchors.fill: parent
    //                     onClicked: modelData.display()
    //                 }
    //             }
    //             Item {
    //                 property var menuHandle: modelData.menu
    //
    //                 // Opener for top-level entries
    //                 QsMenuOpener {
    //                     id: opener
    //                     menu: menuHandle
    //                 }
    //
    //                 Row {
    //                     Repeater {
    //                         model: opener.children
    //                         Rectangle {
    //                             width: 50
    //                             height: 20
    //                             border.color: test ? "#00ff00" : "#0000ff"
    //                             property bool test: true
    //
    //                             color: "#ff0000"   // <— visible background
    //                             MouseArea {
    //                                 anchors.fill: parent
    //                                 onClicked: {
    //                                     test = !test;
    //                                     test = !test;
    //                                     console.log("tray test")
    //                                     test = !test;
    //                                     modelData.triggered();  // triggers the menu action
    //                                 }
    //                             }
    //                             Text {
    //                                 text: modelData.text      // menu item label
    //                                 anchors {
    //                                     centerIn: parent
    //                                 }
    //                             }
    //                         }
    //                     }
    //                 }
    //             }
    //         }
    //
    //         Item { Layout.fillWidth: true }
    //
    //
    //         // Clock
    //         Text {
    //             id: clock
    //             color: root.colBlue
    //             font { family: root.fontFamily; pixelSize: root.fontSize; bold: true }
    //             text: Qt.formatDateTime(new Date(), "ddd, MMM dd - HH:mm")
    //             Timer {
    //                 interval: 1000
    //                 running: true
    //                 repeat: true
    //                 onTriggered: clock.text = Qt.formatDateTime(new Date(), "ddd, MMM dd - HH:mm")
    //             }
    //         }
    //     }
    // }

    Variants {
        model: Quickshell.screens;
        delegate: Component {
            PanelWindow {
                required property var modelData
                screen: modelData
                width: 0;
                height: 0;
                NotifUI {
                    screen: modelData
                }
                PanelWindow {
                    // the screen from the screens list will be injected into this
                    // property

                    // we can then set the window's screen to the injected property
                    screen: modelData

                    id: sideBar
                    color: "#000000ff"
                    width: 75

                    property var currentPopup

                    anchors {
                        top: true
                        bottom: true
                        left: true
                    }
                    // Image {
                    //     source: "/home/tenick/.config/hypr/wallpapers/wallhaven-d6k81o.jpg"
                    //     width: parent.width
                    //     height: parent.height
                    // }
                    Column {
                        // color: "#ffffffff"
                        anchors {
                            fill: parent
                        }

                        // top part (workspaces)
                        Column {
                            anchors {
                                fill: parent
                            }
                            Repeater {
                                model: Hyprland.workspaces

                                Rectangle {
                                    width: 50
                                    height: 24
                                    border.color: modelData.active ? "#00ff00" : "#00ff0000"
                                    border.width: 2
                                    color: "#00ffffff"

                                    MouseArea {
                                        anchors.fill: parent
                                        onClicked: {
                                            Hyprland.dispatch("workspace " + modelData.id)
                                        }
                                    }

                                    Text {
                                        text: modelData.id
                                        color: "#80E0A7"
                                        anchors {
                                            centerIn: parent
                                        }
                                    }
                                }
                            }
                        }

                        // center part
                        Rectangle {
                            color: "#00ff0000"
                            width: 50
                            height: 50
                            anchors {
                                verticalCenter: parent.verticalCenter
                            }
                        }

                        // bottom part
                        Column {
                            anchors {
                                bottom: parent.bottom
                            }

                            // free | awk '/Mem:/ {printf "%.1f\n", $3/1024/1024}'
                            // top -bn1 | grep "Cpu(s)" | awk '{print 100 - $8}'

                            // Battery
                            LiveStat {
                                format: " {0}%"
                                command: ["sh", "-c", "cat /sys/class/power_supply/BAT0/capacity"]
                                interval: 5000
                            }

                            // temp
                            LiveStat {
                                format: " {0}"
                                command: ["sh", "-c", "sensors | grep -m 1 'Package id 0' | awk '{print $4}'"]
                                interval: 1000
                            }

                            // CPU
                            LiveStat {
                                format: " {0}%"
                                command: ["sh", "-c", "-c", "top -bn1 | grep \"Cpu(s)\" | awk '{print 100 - $8}'"]
                                interval: 1000
                            }
                            // RAM
                            LiveStat {
                                format: " {0}G"
                                command: ["sh", "-c", "-c", "free | awk '/Mem:/ {printf \"%.1f\", $3/1024/1024}'"]
                                interval: 1000
                            }
                            // Network
                            LiveStat {
                                format: " {0}%"
                                command: ["sh", "-c", "nmcli -t -f active,ssid,signal dev wifi | grep yes | cut -d':' -f3"]
                                interval: 1000 
                            }
                            // Clock
                            LiveStat {
                                format: " {0}"
                                command: ["date", "+%H:%M:%S"]
                                interval: 1000 
                            }
                            // Day
                            LiveStat {
                                format: "{0}"
                                command: ["sh", "-c", "date \"+%a %b %d\""]
                                interval: 1000 
                            }

                            // Volume
                            Rectangle {
                                id: volumeItem
                                property string volumeOutput
                                width: 75
                                height: 30
                                color: "#00ffffff"
                                Text {
                                    anchors {
                                        centerIn: parent
                                    }
                                    id: volumeText
                                    text: " " + Math.round(Pipewire.defaultAudioSink.audio.volume * 100) + "%"
                                    color: "#80E0A7"
                                    font.family: "DepartureMono Nerd Font Mono"
                                }

                                // scroll up
                                Process {
                                    id: increaseVolumeProc
                                    command: ["sh", "-c", "pactl set-sink-volume @DEFAULT_SINK@ +1%"]
                                    running: false
                                }
                                // scroll down
                                Process {
                                    id: decreaseVolumeProc
                                    command: ["sh", "-c", "pactl set-sink-volume @DEFAULT_SINK@ -1%"]
                                    running: false
                                }

                                MouseArea {
                                    anchors {
                                        fill: parent
                                    }
                                    hoverEnabled: true
                                    onWheel: {
                                        if (wheel.angleDelta.y > 0) {
                                            increaseVolumeProc.running = true
                                        } else if (wheel.angleDelta.y < 0) {
                                            decreaseVolumeProc.running = true
                                        }
                                    }
                                    onEntered: {
                                        volumeItem.color = "#425563"
                                    }
                                    onExited: {
                                        volumeItem.color = "#00ffffff"
                                    }
                                }
                            }

                            // power
                            Rectangle {
                                id: powerItem
                                width: 75
                                height: 30
                                color: "#00ffffff"
                                Text {
                                    anchors {
                                        centerIn: parent
                                    }
                                    text: "⏻"
                                    color: "#80E0A7"
                                    font.family: "DepartureMono Nerd Font Mono"
                                }
                                MouseArea {
                                    anchors {
                                        fill: parent
                                    }
                                    hoverEnabled: true
                                    onClicked: {
                                        powerPopup.visible = !powerPopup.visible
                                    }
                                    onEntered: {
                                        parent.color = "#425563"
                                    }
                                    onExited: {
                                        parent.color = "#00ffffff"
                                    }
                                }
                            }
                        }
                    }

                    PopupWindow {
                        id: powerPopup
                        screen: modelData
                        anchor {
                            window: sideBar
                            rect {
                                x: powerItem.width
                                y: powerItem.parent.y + powerItem.y
                            }
                        }
                        implicitWidth: powerColumn.implicitWidth
                        implicitHeight: powerColumn.implicitHeight
                        color: "transparent"
                        Rectangle {
                            anchors.fill: parent
                            color: "#425563"
                            radius: 10
                            Column {
                                id: powerColumn
                                Row {
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    Rectangle {
                                        color: "transparent"
                                        implicitWidth: shutdownText2.implicitWidth + 20
                                        implicitHeight: shutdownText2.implicitHeight + 20

                                        Text {
                                            anchors {
                                                centerIn: parent
                                            }
                                            id: shutdownText2
                                            text: ""
                                            color: "#80E0A7"
                                            font.family: "DepartureMono Nerd Font Mono"
                                            font.pixelSize: 20
                                        }

                                        Process {
                                            id: sleepProc 
                                            command: ["sh", "-c", "systemctl suspend"]
                                            running: false
                                        }

                                        MouseArea {
                                            anchors {
                                                fill: parent
                                            }
                                            hoverEnabled: true
                                            cursorShape: Qt.PointingHandCursor
                                            onEntered: {
                                                parent.color = "#324553"
                                            }
                                            onExited: {
                                                parent.color = "transparent"
                                            }
                                            onClicked: sleepProc.running = true
                                        }
                                    }
                                    Rectangle {
                                        color: "transparent"
                                        implicitWidth: shutdownText3.implicitWidth + 20
                                        implicitHeight: shutdownText3.implicitHeight + 20
                                        Text {
                                            anchors {
                                                centerIn: parent
                                            }
                                            id: shutdownText3
                                            text: ""
                                            color: "#80E0A7"
                                            font.family: "DepartureMono Nerd Font Mono"
                                            font.pixelSize: 20
                                        }
                                        Process {
                                            id: lockProc
                                            command: ["sh", "-c", "loginctl lock-session"]
                                            running: false
                                        }

                                        MouseArea {
                                            anchors {
                                                fill: parent
                                            }
                                            hoverEnabled: true
                                            cursorShape: Qt.PointingHandCursor
                                            onEntered: {
                                                parent.color = "#324553"
                                            }
                                            onExited: {
                                                parent.color = "transparent"
                                            }
                                            onClicked: lockProc.running = true
                                        }
                                    }
                                    Rectangle {
                                        color: "transparent"
                                        implicitWidth: shutdownText.implicitWidth + 20
                                        implicitHeight: shutdownText.implicitHeight + 20
                                        Text {
                                            anchors {
                                                centerIn: parent
                                            }
                                            id: rebootText
                                            text: "󰑓"
                                            color: "#80E0A7"
                                            font.family: "DepartureMono Nerd Font Mono"
                                            font.pixelSize: 20
                                        }
                                        Process {
                                            id: rebootProc 
                                            command: ["sh", "-c", "reboot"]
                                            running: false
                                        }

                                        MouseArea {
                                            anchors {
                                                fill: parent
                                            }
                                            hoverEnabled: true
                                            cursorShape: Qt.PointingHandCursor
                                            onEntered: {
                                                parent.color = "#324553"
                                            }
                                            onExited: {
                                                parent.color = "transparent"
                                            }
                                            onClicked: rebootProc.running = true
                                        }
                                    }
                                    Rectangle {
                                        color: "transparent"
                                        implicitWidth: shutdownText.implicitWidth + 20
                                        implicitHeight: shutdownText.implicitHeight + 20
                                        Text {
                                            anchors {
                                                centerIn: parent
                                            }
                                            id: shutdownText
                                            text: ""
                                            color: "#80E0A7"
                                            font.family: "DepartureMono Nerd Font Mono"
                                            font.pixelSize: 20
                                        }
                                        Process {
                                            id: shutdownProc 
                                            command: ["sh", "-c", "shutdown now"]
                                            running: false
                                        }

                                        MouseArea {
                                            anchors {
                                                fill: parent
                                            }
                                            hoverEnabled: true
                                            cursorShape: Qt.PointingHandCursor
                                            onEntered: {
                                                parent.color = "#324553"
                                            }
                                            onExited: {
                                                parent.color = "transparent"
                                            }
                                            onClicked: shutdownProc.running = true
                                        }
                                    }
                                }

                                WrapperItem {
                                    leftMargin: 10
                                    Row {
                                        id: brightnessRow

                                        WrapperItem  {
                                            Text {
                                                anchors.verticalCenter: brightnessRow.verticalCenter
                                                text: `󰌵`
                                                color: "#80E0A7"
                                                font.family: "DepartureMono Nerd Font Mono"
                                                font.pixelSize: 20
                                            }
                                        }
                                        Slider {
                                            id: brightnessSlider
                                            anchors.verticalCenter: brightnessRow.verticalCenter
                                            value: 0.5
                                            property bool isInternalPanel: screen.name.startsWith("eDP")
                                                || screen.name.startsWith("LVDS")

                                            onValueChanged: {
                                                console.log(brightnessSlider.value, Math.round(brightnessSlider.value * 100))
                                                brightnessSlider.enabled = false
                                                brightnessProc.command = [
                                                    "sh",
                                                    "-c",
                                                    isInternalPanel
                                                    ? `brightnessctl s ${Math.round(brightnessSlider.value * 100)}%`
                                                    : `ddcutil setvcp 10 ${Math.round(brightnessSlider.value * 100)}`
                                                ]
                                                brightnessProc.running = true
                                            }
                                            Process {
                                                id: brightnessProc
                                                running: false
                                                onExited: {
                                                    brightnessSlider.enabled = true;
                                                    console.log("done changed to", brightnessSlider.value)
                                                }
                                            }
                                        }
                                        WrapperItem {
                                            leftMargin: 10
                                            Text {
                                                anchors.verticalCenter: brightnessRow.verticalCenter
                                                text: "󰜉"
                                                color: "#80E0A7"
                                                font.family: "DepartureMono Nerd Font Mono"
                                                font.pixelSize: 20

                                                MouseArea {
                                                    anchors.fill: parent
                                                    onClicked: {
                                                        brightnessSlider.value = 0.5
                                                        brightnessProc.running = true
                                                    }
                                                    hoverEnabled: true
                                                    cursorShape: Qt.PointingHandCursor
                                                    onEntered: {
                                                        parent.color = "#20A063"
                                                    }
                                                    onExited: {
                                                        parent.color = "#80E0A7"
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }

                                WrapperItem {
                                    leftMargin: 10
                                    Row {
                                        id: nightLightRow
                                        WrapperItem {
                                            Text {
                                                anchors.verticalCenter: nightLightRow.verticalCenter
                                                text: "󰖔"
                                                color: "#80E0A7"
                                                font.family: "DepartureMono Nerd Font Mono"
                                                font.pixelSize: 20
                                            }
                                        }
                                        Slider {
                                            id: nightLightSlider
                                            anchors.verticalCenter: nightLightRow.verticalCenter
                                            value: 6500/(25000-1000)
                                            onValueChanged: {
                                                nightLightKillProc.running = true 
                                                console.log(nightLightSlider.value, Math.round(nightLightSlider.value * (25000-1000)+1000))
                                            }
                                            Process {
                                                id: nightLightKillProc
                                                command: ["sh", "-c", "pkill gammastep"]
                                                running: false
                                                onExited: {
                                                    nightLightProc.running = true
                                                }
                                            }
                                            Process {
                                                id: nightLightProc
                                                command: ["sh", "-c", "gammastep -O " + Math.round(nightLightSlider.value * (25000-1000)+1000) + " &"]
                                                running: false
                                            }
                                        }
                                        WrapperItem {
                                            leftMargin: 10
                                            Text {
                                                anchors.verticalCenter: nightLightRow.verticalCenter
                                                text: "󰜉"
                                                color: "#80E0A7"
                                                font.family: "DepartureMono Nerd Font Mono"
                                                font.pixelSize: 20

                                                MouseArea {
                                                    anchors.fill: parent
                                                    onClicked: {
                                                        nightLightSlider.value = 6500/(25000-1000)
                                                        nightLightKillProc.running = true
                                                    }
                                                    hoverEnabled: true
                                                    cursorShape: Qt.PointingHandCursor
                                                    onEntered: {
                                                        parent.color = "#20A063"
                                                    }
                                                    onExited: {
                                                        parent.color = "#80E0A7"
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }

	//    FloatingWindow {
	// 	// match the system theme background color
	// 	color: contentItem.palette.active.window
	//        visible: false
	//
	// 	ScrollView {
	// 		anchors.fill: parent
	// 		contentWidth: availableWidth
	//
	// 		Column {
	// 			anchors.fill: parent
	// 			anchors.margins: 10
	//
	// 			// get a list of nodes that output to the default sink
	// 			PwNodeLinkTracker {
	// 				id: linkTracker
	// 				node: Pipewire.defaultAudioSink
	// 			}
	//
	// 			MixerEntry {
	// 				node: Pipewire.defaultAudioSink
	// 			}
	//
	// 			Rectangle {
	// 				Layout.fillWidth: true
	// 				color: palette.active.text
	// 				implicitHeight: 1
	// 			}
	//
	// 			Repeater {
	// 				model: linkTracker.linkGroups
	//
	// 				MixerEntry {
	// 					required property PwLinkGroup modelData
	// 					// Each link group contains a source and a target.
	// 					// Since the target is the default sink, we want the source.
	// 					node: modelData.source
	// 				}
	// 			}
	// 		}
	// 	}
	// }
}
