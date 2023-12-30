import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts
import BookModelLib

/*
Delegate item for BookList. Displays the annotation, date and optionally
the book title if section headers are disabled. Allows assigning of color
labels to annotations, as well as notes. Annotation can be highlighted and
copied with system keyboard shortcuts, or by using the copy button located
in the top-left corner of the delegate.
 */
Item {
    id: delegateRoot

    // Base model index, useful for nested models
    property var delegateIndex: index
    // True if this delegate is part of an expanded section
    property bool expanded: ListView.view.isExpanded(title)
    // The highlight colors as dictated by the parent view
    property var highlightColors: ListView.view.getHighlightColors()
    // The highlight weights as dictated by the parent view
    property var highlightWeights: ListView.view.getHighlightWeights()

    // 0 height if part of a collapsed section, otherwise some spacing around
    // the annotations height to add the other elements
    height: expanded ? annotationElement.implicitHeight + 60 : 0
    // Invisible if collapsed
    visible: expanded
    // Inherit width from view
    width: ListView.view.width

    // Smoothing for section collapsing
    Behavior on height {
        NumberAnimation {
            duration: 200
        }
    }

    // Annotation element
    TextArea {
        id: annotationElement

        anchors.fill: parent
        anchors.leftMargin: 30
        anchors.rightMargin: 30
        horizontalAlignment: Text.AlignLeft
        hoverEnabled: true
        readOnly: true
        text: model.text
        color: "white"
        verticalAlignment: Text.AlignVCenter
        wrapMode: Text.WordWrap
    }

    // Column containing the copy button and notes button
    Column {
        anchors.left: parent.left
        anchors.leftMargin: 0
        anchors.verticalCenter: parent.verticalCenter

        // Button for copying the annotation text
        RoundHoverButton {
            opacity: (annotationElement.hovered || buttonHovered) ? 1 : 0
            text: "\uF0C5"
            
            onClicked: {
                kaeLib.copyToClipboard(model.text);
                kaeLib.showToast("Copied to clipboard");
            }
        }
        // Button for displaying the notes UI
        RoundHoverButton {
            text: "\uF0F6"

            onClicked: {
                console.log("notes at index",index, "are",model.notes);
                notesPopup.setNoteString(model.notes);
                notesPopup.setOpeningIndex(delegateRoot.delegateIndex);
                notesPopup.open();
            }
        }
    }

    // Row containing the highlight selectors
    Row {
        anchors.right: dateText.left
        anchors.verticalCenter: dateText.verticalCenter
        spacing: 5

        // Repeats small colored circles that apply the selected highlight
        // color on click
        Repeater {
            model: delegateRoot.highlightColors

            Rectangle {
                property bool colorChosen: (highlightColor % delegateRoot.highlightWeights[index]) == 0

                border.color: subMouseArea.containsMouse ? "white" : "transparent"
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

    // Contains the date text
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
        color: "white"
        verticalAlignment: Text.AlignTop
        wrapMode: Text.WordWrap
    }

    // Contains the book title. Only visible when section
    // headers are disabled
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
        color: "white"
    }
    // Background element
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

