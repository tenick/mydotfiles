import QtQuick // for Text
import Quickshell // for PanelWindow
import Quickshell.Io // for Process
import Quickshell.Wayland
import Quickshell.Hyprland
import Quickshell.Services.Pipewire
import QtQuick.Controls
import "LiveStat.qml"

ShellRoot {
    PwObjectTracker {
        objects: [Pipewire.defaultAudioSink]
    }

    PanelWindow {
        color: "#000000ff"
        width: 75

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
                        onWheel: {
                            if (wheel.angleDelta.y > 0) {
                                increaseVolumeProc.running = true
                            } else if (wheel.angleDelta.y < 0) {
                                decreaseVolumeProc.running = true
                            }
                        }
                    }
                }
            }
        }
    }
}
