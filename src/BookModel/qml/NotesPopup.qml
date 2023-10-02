import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts
//import Qt5Compat.GraphicalEffects

/* NotesPopup
Popup used to interact with notes created for annotations.
 */
Drawer {
    id: popup

    edge: Qt.RightEdge
    width: parent.width * 0.33
    height: parent.height
    // array of notes
    property var notes
    // model idx that opened the popup
    property var idx

    // Returns the notes array as a comma seperated list
    function getNoteString() {
        return notes.join(";");
    }

    function getOpeningIndex() {
        return idx;
    }

    function setOpeningIndex(index) {
        idx = index;
    }

    // Splits a string on commas and sets it as the popups
    // model data
    function setNoteString(noteString) {
        if (noteString) {
            popup.notes = noteString.split(";");
        }
        else
            popup.notes = [];
        noteListView.model = notes;

    }

    //anchors.centerIn: Overlay.overlay
    focus: true
    // height: 600
    // padding: 10
    // width: 400

    background: Rectangle {
        id: popupBackground

        anchors.fill: parent
        border.color: palette.alternateBase
        color: palette.window
        // radius: 20
    }

    // DropShadow {
    //     color: "#80000000"
    //     height: popup.height
    //     samples: 30
    //     source: popupBackground
    //     verticalOffset: 10
    //     width: popup.width
    //     x: -leftPadding
    //     y: -topPadding
    // }
    ColumnLayout {
        anchors.fill: parent
        spacing: 5

        RowLayout {
            Layout.fillWidth: true
            Layout.preferredHeight: 1

            TextField {
                id: noteAdder
                Layout.fillHeight: true
                Layout.fillWidth: true
                color: palette.text
                placeholderText: "Type a note and press enter"

                background: Rectangle {
                    border.color: "transparent"
                    color: palette.button
                    // radius: 20
                }

                onAccepted: {
                    notes.push(text);
                    noteListView.model = notes;
                    text = "";
                }
            }
        }
        RowLayout {
            Layout.fillWidth: true
            Layout.preferredHeight: 9

            ListView {
                id: noteListView

                Layout.fillHeight: true
                Layout.fillWidth: true
                clip: true
                model: notes
                spacing: 0

                // delegate
                delegate: Item {
                    clip: true
                    height: noteElement.height + 20
                    width: ListView.view.width

                    // Note element
                    TextArea {
                        id: noteElement

                        anchors.fill: parent
                        anchors.leftMargin: 30
                        anchors.rightMargin: 30
                        horizontalAlignment: Text.AlignLeft
                        hoverEnabled: true
                        readOnly: true
                        text: modelData
                        verticalAlignment: Text.AlignVCenter
                        wrapMode: Text.WordWrap
                    }
                    RoundHoverButton {
                        anchors.right: parent.right
                        anchors.rightMargin: 1
                        anchors.verticalCenter: parent.verticalCenter
                        text: "\uF0C5"

                        onClicked: {
                            kaeLib.copyToClipboard(modelData);
                            kaeLib.showToast("Copied to clipboard");
                        }
                    }
                    RoundHoverButton {
                        anchors.left: parent.left 
                        anchors.leftMargin: 3
                        anchors.verticalCenter: parent.verticalCenter 
                        text: "x"

                        onClicked: {
                            notes.splice(index,1);
                            noteListView.model = notes;
                        }
                    }
                }
            }
        }
    }
}
