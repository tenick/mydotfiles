import QtQuick // for Text
import Quickshell // for PanelWindow
import Quickshell.Io // for Process

Rectangle {
    id: root
    property var command
    property string textColor: "#80E0A7"
    property int interval: 2000
    property string output
    property string format
    width: 75
    height: 30 
    color: "#00ffffff"

    Text {
        anchors {
            centerIn: parent
        }
        id: label
        color: root.textColor
        font.family: "DepartureMono Nerd Font Mono"
        text: format.replace("{0}", root.output.trim())
    }

    Process {
        id: proc
        command: root.command
        running: true

        stdout: StdioCollector {
            onStreamFinished: root.output = this.text
        }
    }

    Timer {
        interval: root.interval
        running: true
        repeat: true
        onTriggered: proc.running = true
    }
}

