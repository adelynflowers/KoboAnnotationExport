import QtQuick 
import QtQuick.Controls 

Page {
    title: qsTr("Third page")
    Label {
        text: qsTr("Ok end of the line bucko")
    }
    Row {
        anchors.centerIn: parent 
        ToolButton {
            text: qsTr("Press to go back one")
            onClicked: stackView.pop()
        }
        ToolButton {
            text: qsTr("Press to go home")
            onClicked: {
                // Back to second
                stackView.pop()
                // Back to first
                stackView.pop()
            }
        }
    }

}