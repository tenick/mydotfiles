import QtQuick
import Quickshell

PanelWindow {
    id: notifUIRoot
    anchors {
        top: true
        right: true
    }
    implicitWidth: 300
    implicitHeight: Math.min(notifListView.contentHeight, screen.height)

    color: "transparent"

    ListView {
        id: notifListView
        anchors.fill: parent
        spacing: 4
        clip: true
        model: NotifHandler.notifs

        delegate: Rectangle {
            required property int index
            property var modelData: NotifHandler.notifs.get(index)?.notif
            property var modelDataId: NotifHandler.notifs.get(index)?.id

            implicitWidth: ListView.view.width
            implicitHeight: 70
            color: "#2c3e50"
            radius: 8
            border.color: "#80E0A7"
            border.width: 1

            Row {
                anchors.fill: parent
                anchors.margins: 6
                spacing: 6

                Image {
                    source: modelData?.image || modelData?.appIcon || ""
                    width: 58
                    height: 58
                    visible: source !== ""
                    fillMode: Image.PreserveAspectFit
                    clip: true
                }

                Column {
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: 2

                    Text {
                        text: modelData?.summary || "(no title)"
                        color: "#80E0A7"
                        font.pixelSize: 14
                        font.bold: true
                        width: 210
                        font.family: "DepartureMono Nerd Font Mono"
                        elide: Text.ElideRight
                    }

                    Text {
                        text: modelData?.body || ""
                        width: 210
                        color: "#c0c0c0"
                        font.pixelSize: 12
                        font.family: "DepartureMono Nerd Font Mono"
                        elide: Text.ElideRight
                    }
                }
            }

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    NotifHandler.remove(modelDataId);
                }

                hoverEnabled: true
                onEntered: {
                    NotifHandler.pause(modelDataId);
                }
                onExited: {
                    NotifHandler.resume(modelDataId);
                }
            }
        }
    }
}
