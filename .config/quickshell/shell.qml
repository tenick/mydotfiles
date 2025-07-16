import QtQuick // for Text
import QtQuick.Controls
import QtQuick.Layouts

import Quickshell // for PanelWindow
import Quickshell.Io // for Process
import Quickshell.Wayland
import Quickshell.Hyprland
import Quickshell.Services.Pipewire
import Quickshell.Services.Notifications
import Quickshell.Widgets
import "LiveStat.qml"
import "Notif.qml"


ShellRoot {
    id: shellRoot

    PwObjectTracker {
        objects: [Pipewire.defaultAudioSink]
    }

    // PanelWindow {
    //     id: notifPanel
    //     anchors {
    //         top: true
    //         right: true
    //     }
    //     width: 200
    //
    //     Column {
    //         Rectangle {
    //             implicitWidth: ohya.implicitWidth
    //             implicitHeight: ohya.implicitHeight
    //             color: "transparent"
    //             Text {
    //                 id: ohya
    //                 text: "oh yaaa"
    //             }
    //
    //             Process {
    //
    //             }
    //
    //             MouseArea {
    //                 anchors.fill: parent
    //                 onClicked: {
    //                     console.log("Rectangle clicked")
    //                 }
    //                 hoverEnabled: true
    //                 onEntered: {
    //                     parent.color = "#324553"
    //                 }
    //                 onExited: {
    //                     parent.color = "transparent"
    //                 }
    //             }
    //         }
    //         Rectangle {
    //             implicitWidth: ohya3.implicitWidth
    //             implicitHeight: ohya3.implicitHeight
    //             color: "lightblue"
    //             Text {
    //                 id: ohya3
    //                 text: "oh yaaa333"
    //             }
    //
    //             MouseArea {
    //                 anchors.fill: parent
    //                 onClicked: {
    //                     console.log("Rectangle3 clicked")
    //                 }
    //             }
    //         }
    //     }
    //
    //     Rectangle {
    //         id: notifRect
    //         Text {
    //             id: notifText
    //             text: "text??枝本順三郎"
    //             font.family: "DepartureMono Nerd Font Mono"
    //         }
    //     }
    //     Timer {
    //         interval: 1000
    //         running: true
    //         repeat: true
    //         onTriggered: notifText.text = Notif.notifList.length
    //     }
    // }

    // PanelWindow {
    //     anchors {
    //         top: true
    //         bottom: true
    //     }
    //     Rectangle {
    //         anchors {
    //             centerIn: parent
    //         }
    //         color: "#ff0000"
    //         width: 100
    //         height: 100
    //     }
    // }

    PanelWindow {
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
                    command: ["sh", "-c", "date \"+%a %b\""]
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
                        rightMargin: 10
                        Row {
                            id: brightnessRow

                            WrapperItem  {
                                rightMargin: 10
                                Text {
                                    anchors.verticalCenter: brightnessRow.verticalCenter
                                    text: "󰌵"
                                    color: "#80E0A7"
                                    font.family: "DepartureMono Nerd Font Mono"
                                    font.pixelSize: 20
                                }
                            }
                            Slider {
                                id: brightnessSlider
                                anchors.verticalCenter: brightnessRow.verticalCenter
                                value: 0.5
                                onValueChanged: {
                                    console.log(brightnessSlider.value, Math.round(brightnessSlider.value * 100))
                                    brightnessSlider.enabled = false
                                    brightnessProc.command = ["sh", "-c", "ddcutil setvcp 10 " + Math.round(brightnessSlider.value * 100)]
                                    brightnessProc.running = true
                                }
                                Process {
                                    id: brightnessProc
                                    command: ["sh", "-c", "ddcutil setvcp 10 " + Math.round(brightnessSlider.value * 100)]
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
                        rightMargin: 10
                        Row {
                            id: nightLightRow
                            WrapperItem {
                                rightMargin: 10
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
                                // enabled: false
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

    FloatingWindow {
		// match the system theme background color
		color: contentItem.palette.active.window
        visible: false

		ScrollView {
			anchors.fill: parent
			contentWidth: availableWidth

			Column {
				anchors.fill: parent
				anchors.margins: 10

				// get a list of nodes that output to the default sink
				PwNodeLinkTracker {
					id: linkTracker
					node: Pipewire.defaultAudioSink
				}

				MixerEntry {
					node: Pipewire.defaultAudioSink
				}

				Rectangle {
					Layout.fillWidth: true
					color: palette.active.text
					implicitHeight: 1
				}

				Repeater {
					model: linkTracker.linkGroups

					MixerEntry {
						required property PwLinkGroup modelData
						// Each link group contains a source and a target.
						// Since the target is the default sink, we want the source.
						node: modelData.source
					}
				}
			}
		}
	}
}
