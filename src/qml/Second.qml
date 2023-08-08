import QtQuick 
import QtQuick.Controls 

Page {
    title: qsTr("Second page")

    ToolButton {
        id: toolButton 
        text: "Press to go to THIRD page" 
        anchors.centerIn: parent
        onClicked: stackView.push("Third.qml")

    }

}