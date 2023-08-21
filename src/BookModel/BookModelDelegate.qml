import QtQuick 
import QtQuick.Controls
import QtQuick.Layouts
import BookModelLib

Item {
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
    Button {
        id: copyButton
        text: "\uF0C5"
        font.family: "fontello"
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left 
        anchors.leftMargin: 0
        onClicked: {
            kaeLib.copyToClipboard(model.text)
            kaeLib.showToast("Copied to clipboard")
        }
        hoverEnabled: true
        width: implicitWidth + 10
        height: implicitHeight + 10
        //visible: hovered ? 1: 0
        opacity: (annotationMouseArea.containsMouse || copyMouseArea.containsMouse) ? 1 : 0
        background: Rectangle {
            id: copyMouseArea
            anchors.fill: parent
            radius: 50
            color: "transparent"
            border.color: "white"
            border.width: 2
            opacity: parent.hovered ? 1 : 0
            Rectangle {
                radius: parent.radius
                anchors.fill: parent 
                color: "white"
                opacity: copyButton.pressed ? 0.3 : 0
            }
        }
        Behavior on opacity {
            NumberAnimation {duration: 200}
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

    // RowLayout {
    //     id: col
    //     width: parent.width
    //     z: 2
    //     ColumnLayout {
    //         Layout.fillHeight: true 
    //         Layout.preferredWidth: 1
    //         Button {
    //             text: "\uF0C5"
    //             font.family: "fontello"
    //             flat: true
    //             Layout.fillHeight: false
    //             Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
    //             Layout.topMargin: 10
    //             z: 2
    //             onClicked: kaeLib.copyToClipboard(model.text)
    //         }
    //     }
    //     ColumnLayout {
    //         Layout.preferredWidth: 8 
    //         Layout.fillHeight: true
    //         TextArea {
    //             selectByMouse: true 
    //             readOnly: true
    //             id: textItem2
    //             Layout.fillWidth: true
    //             Layout.topMargin: 10
    //             Layout.leftMargin: 20
    //             Layout.rightMargin: 50
    //             horizontalAlignment: Text.AlignLeft
    //             text: model.text
    //             wrapMode: Text.WordWrap
    //         }
    //     }
    //     ColumnLayout {
    //         Layout.preferredWidth: 1
    //         Layout.fillHeight: true 
    //         Label {
    //             Layout.topMargin: 10
    //             Layout.rightMargin: 5
    //             Layout.fillWidth: true 
    //             Layout.fillHeight: true 
    //             verticalAlignment: Text.AlignTop
    //             horizontalAlignment: Text.AlignRight
    //             text: model.date
    //             font.italic: true 
    //             wrapMode: Text.WordWrap
    //             color: palette.placeholderText
    //         }
    //     }
    // }
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



