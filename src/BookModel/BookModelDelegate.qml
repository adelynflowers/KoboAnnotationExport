import QtQuick 
import QtQuick.Controls.Basic
import QtQuick.Layouts
import BookModelLib

Item {
    id: delegateRoot
    property var delegateIndex: index
    property var highlightWeights: ([2,3,5])
    property bool expanded: ListView.view.isExpanded(title)
    property var highlightColors: (["red", "green", "blue"])
    width: ListView.view.width
    height: expanded ? textItem2.implicitHeight + 60 : 0
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
            contentItem: Text {
                text: parent.text
                font: parent.font
                opacity: enabled ? 1.0 : 0.3
                color: parent.pressed ? palette.buttonText : palette.windowText
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                elide: Text.ElideRight
            }
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
                radius: 500
                color: "transparent"
                border.color: palette.button
                border.width: 2
                opacity: copyMouseArea.containsMouse ? 1 : 0
                Rectangle {
                    radius: parent.radius
                    anchors.fill: parent 
                    color: palette.button
                    opacity: copyButton.pressed ? 1 : 0
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
            font.family: "fontello"
            contentItem: Text {
                text: "\uF0F6"
                font.family: "fontello"
                opacity: enabled ? 1.0 : 0.3
                color: parent.pressed ? palette.buttonText : palette.windowText
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                elide: Text.ElideRight
            }
            width: implicitWidth + 10
            height: implicitHeight + 10
            onClicked: {
                console.log(index)
                kaeLib.showToast(index)
            }
            background: Rectangle {
                anchors.fill: parent
                radius: 500
                color: "transparent"
                border.color: palette.button
                border.width: 2
                opacity: notesMouseArea.containsMouse ? 1 : 0
                Rectangle {
                    radius: parent.radius
                    anchors.fill: parent 
                    color: palette.button
                    opacity: notesButton.pressed ? 1 : 0
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
            model: delegateRoot.highlightColors
            Rectangle {
                height: 15
                width: 15
                radius: 500
                color: modelData
                property bool colorChosen: (highlightColor % delegateRoot.highlightWeights[index]) == 0
                opacity: (
                    annotationMouseArea.containsMouse || 
                    subMouseArea.containsMouse || 
                    colorChosen) ? 1 : 0
                border.color: subMouseArea.containsMouse ? palette.windowText : "transparent"
                Behavior on opacity {
                    NumberAnimation{duration: 200}
                }
                MouseArea {
                    id: subMouseArea
                    anchors.fill: parent 
                    hoverEnabled: true
                    onClicked: {
                        let weight = delegateRoot.highlightWeights[index];
                        if (!parent.colorChosen) {
                            delegateRoot.ListView.view.addColor(delegateRoot.delegateIndex, weight);
                        } else {
                            delegateRoot.ListView.view.removeColor(delegateRoot.delegateIndex, weight);
                        } 
                    }
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
        color: "transparent"
        border.width: 1
        radius: 2
        border.color: palette.alternateBase
    }
}



