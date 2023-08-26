import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts
import BookModelLib

Item {
    id: delegateRoot

    property var delegateIndex: index
    property bool expanded: ListView.view.isExpanded(title)
    property var highlightColors: ListView.view.getHighlightColors()
    property var highlightWeights: ListView.view.getHighlightWeights()

    height: expanded ? annotationElement.implicitHeight + 60 : 0
    visible: expanded ? true : false
    width: ListView.view.width

    Behavior on height {
        NumberAnimation {
            duration: 200
        }
    }

    TextArea {
        id: annotationElement

        anchors.fill: parent
        anchors.leftMargin: 30
        anchors.rightMargin: 30
        horizontalAlignment: Text.AlignLeft
        hoverEnabled: true
        readOnly: true
        text: model.text
        verticalAlignment: Text.AlignVCenter
        wrapMode: Text.WordWrap
    }
    Column {
        anchors.left: parent.left
        anchors.leftMargin: 0
        anchors.verticalCenter: parent.verticalCenter

        Button {
            id: copyButton

            font.family: "fontello"
            height: implicitHeight + 5
            hoverEnabled: true
            opacity: (annotationElement.hovered || copyMouseArea.containsMouse) ? 1 : 0
            text: "\uF0C5"
            width: implicitWidth + 5

            background: Rectangle {
                anchors.fill: parent
                border.color: palette.button
                border.width: 2
                color: "transparent"
                opacity: copyMouseArea.containsMouse ? 1 : 0
                radius: 500

                Rectangle {
                    anchors.fill: parent
                    color: palette.button
                    opacity: copyButton.pressed ? 1 : 0
                    radius: parent.radius
                }
                MouseArea {
                    id: copyMouseArea

                    anchors.fill: parent
                    hoverEnabled: true
                }
            }
            contentItem: Text {
                color: parent.pressed ? palette.buttonText : palette.windowText
                elide: Text.ElideRight
                font: parent.font
                horizontalAlignment: Text.AlignHCenter
                opacity: enabled ? 1.0 : 0.3
                text: parent.text
                verticalAlignment: Text.AlignVCenter
            }
            Behavior on opacity {
                NumberAnimation {
                    duration: 200
                }
            }

            onClicked: {
                kaeLib.copyToClipboard(model.text);
                kaeLib.showToast("Copied to clipboard");
            }
        }
        Button {
            id: notesButton

            font.family: "fontello"
            height: implicitHeight + 5
            width: implicitWidth + 5

            background: Rectangle {
                anchors.fill: parent
                border.color: palette.button
                border.width: 2
                color: "transparent"
                opacity: notesMouseArea.containsMouse ? 1 : 0
                radius: 500

                Rectangle {
                    anchors.fill: parent
                    color: palette.button
                    opacity: notesButton.pressed ? 1 : 0
                    radius: parent.radius
                }
                MouseArea {
                    id: notesMouseArea

                    anchors.fill: parent
                    hoverEnabled: true
                }
            }
            contentItem: Text {
                color: parent.pressed ? palette.buttonText : palette.windowText
                elide: Text.ElideRight
                font.family: "fontello"
                horizontalAlignment: Text.AlignHCenter
                opacity: enabled ? 1.0 : 0.3
                text: "\uF0F6"
                verticalAlignment: Text.AlignVCenter
            }

            onClicked: {
                console.log(index);
                kaeLib.showToast(index);
            }
        }
    }
    Row {
        anchors.right: dateText.left
        anchors.verticalCenter: dateText.verticalCenter
        spacing: 5

        Repeater {
            model: delegateRoot.highlightColors

            Rectangle {
                property bool colorChosen: (highlightColor % delegateRoot.highlightWeights[index]) == 0

                border.color: subMouseArea.containsMouse ? palette.windowText : "transparent"
                color: modelData
                //TODO: Figure out opacity animation
                height: 15
                opacity: (annotationElement.hovered || subMouseArea.containsMouse || colorChosen) ? 1 : 0
                radius: 500
                width: 15

                Behavior on opacity {
                    NumberAnimation {
                        duration: 200
                    }
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

        anchors.right: parent.right
        anchors.rightMargin: 3
        anchors.top: parent.top
        anchors.topMargin: 1
        font.italic: true
        horizontalAlignment: Text.AlignRight
        readOnly: true
        selectByMouse: true
        text: Qt.formatDate(model.date, "MMM dd, yyyy")
        verticalAlignment: Text.AlignTop
        wrapMode: Text.WordWrap
    }
    TextArea {
        id: sectionLabel

        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.rightMargin: 3
        font.italic: true
        horizontalAlignment: Text.AlignRight
        readOnly: true
        selectByMouse: true
        text: model.title
        verticalAlignment: Text.AlignTop
        visible: !parent.ListView.view.sectionsEnabled
        wrapMode: Text.WordWrap
    }
    Popup {
        id: popup

        anchors.centerIn: Overlay.overlay
        focus: true
        padding: 10

        contentItem: Column {
            spacing: 5

            Repeater {
                model: ["hello", "hello!", "hi"]

                Label {
                    horizontalAlignment: Text.AlignLeft
                    text: modelData
                    verticalAlignment: Text.AlignVCenter
                }
            }
        }
    }
    Rectangle {
        anchors.fill: parent
        anchors.leftMargin: -1
        anchors.rightMargin: -1
        anchors.topMargin: 0
        border.color: palette.alternateBase
        border.width: 1
        color: "transparent"
        opacity: 0.3
        radius: 2
        z: 1
    }
}

