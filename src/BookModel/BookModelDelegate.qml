import QtQuick 
import QtQuick.Controls
import QtQuick.Layouts
import BookModelLib

Item {
    id: delegateRoot
    property bool expanded: ListView.view.isExpanded(title)
    width: ListView.view.width
    height: expanded ? textItem2.implicitHeight + 40 : 0
    visible: expanded ? true : false
    Behavior on height {
        NumberAnimation{duration: 200}
    }
    TextArea {
        selectByMouse: true 
        readOnly: true
        id: textItem2
        anchors.fill: parent
        anchors.leftMargin: 30
        anchors.rightMargin: 30
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
        text: model.text
        wrapMode: Text.WordWrap
        MouseArea {
            id: annotationMouseArea
            anchors.fill: parent 
            hoverEnabled: true
        }
    }
    Column {
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left 
        anchors.leftMargin: 0
        Button {
            id: copyButton
            text: "\uF0C5"
            font.family: "fontello"
            onClicked: {
                kaeLib.copyToClipboard(model.text)
                kaeLib.showToast("Copied to clipboard")
            }
            hoverEnabled: true
            width: implicitWidth + 10
            height: implicitHeight + 10
            opacity: (annotationMouseArea.containsMouse || copyMouseArea.containsMouse) ? 1 : 0
            background: Rectangle {
                anchors.fill: parent
                radius: 50
                color: "transparent"
                border.color: "white"
                border.width: 2
                opacity: copyMouseArea.containsMouse ? 1 : 0
                Rectangle {
                    radius: parent.radius
                    anchors.fill: parent 
                    color: "white"
                    opacity: copyButton.pressed ? 0.3 : 0
                }
                MouseArea {
                    id: copyMouseArea
                    hoverEnabled: true      
                    anchors.fill: parent

                }
            }
            Behavior on opacity {
                NumberAnimation {duration: 200}
            }
            
        }
        Button {
            id: notesButton
            text: "\uF0F6"
            font.family: "fontello"
            width: implicitWidth + 10
            height: implicitHeight + 10
            onClicked: popup.open()
            background: Rectangle {
                anchors.fill: parent
                radius: 50
                color: "transparent"
                border.color: "white"
                border.width: 2
                opacity: notesMouseArea.containsMouse ? 1 : 0
                Rectangle {
                    radius: parent.radius
                    anchors.fill: parent 
                    color: "white"
                    opacity: notesButton.pressed ? 0.3 : 0
                }
                MouseArea {
                    id: notesMouseArea
                    hoverEnabled: true      
                    anchors.fill: parent

                }
            }
        }
        
    }
    Row {
        spacing: 5
        anchors.verticalCenter: dateText.verticalCenter
        anchors.right: dateText.left
        Repeater {
            model: ["red", "blue", "green"]
            Rectangle {
                height: 15
                width: 15
                radius: 500
                color: modelData
                opacity: (annotationMouseArea.containsMouse || subMouseArea.containsMouse) ? 1 : 0
                border.color: subMouseArea.containsMouse ? "white" : "transparent"
                Behavior on opacity {
                    NumberAnimation{duration: 200}
                }
                MouseArea {
                    id: subMouseArea
                    anchors.fill: parent 
                    hoverEnabled: true
                }
            }
           

        }
    }
    TextArea {
        id: dateText
        selectByMouse: true 
        readOnly: true
        anchors.right: parent.right 
        anchors.top: parent.top 
        anchors.topMargin: 1
        anchors.rightMargin: 3
        verticalAlignment: Text.AlignTop
        horizontalAlignment: Text.AlignRight
        text: model.date
        font.italic: true 
        wrapMode: Text.WordWrap
    }
    TextArea {
        id: sectionLabel
        selectByMouse: true 
        readOnly: true
        anchors.right: parent.right 
        anchors.bottom: parent.bottom
        anchors.rightMargin: 3
        verticalAlignment: Text.AlignTop
        horizontalAlignment: Text.AlignRight
        text: model.title
        font.italic: true 
        wrapMode: Text.WordWrap
        visible: !parent.ListView.view.sectionsEnabled
    }

    Popup {
        id: popup
        padding: 10 
        anchors.centerIn: Overlay.overlay 
        focus: true
        contentItem: Column {
            spacing: 5 
            Repeater {
                model: ["hello", "hello!", "hi"]
                Label {
                    text: modelData 
                    horizontalAlignment: Text.AlignLeft
                    verticalAlignment: Text.AlignVCenter
                }
            }
        }
    }

    Rectangle {
        anchors.fill: parent
        anchors.rightMargin: -1
        anchors.topMargin: 0
        anchors.leftMargin: -1
        z: 1
        opacity: 0.3
        color: palette.window
        border.width: 1
        radius: 2
        border.color: palette.alternateBase
    }
}



