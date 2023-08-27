import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts

/* NotesPopup
Popup used to interact with notes created for annotations.
 */
Popup {
    id: popup

    // array of notes
    property var notes

    // Returns the notes array as a comma seperated list
    function getNoteString() {
        return notes.join(",");
    }

    // Splits a string on commas and sets it as the popups
    // model data
    function setNoteString(noteString) {
        if (noteString)
            popup.notes = noteString.split(",");
        else
            popup.notes = [];
    }

    anchors.centerIn: Overlay.overlay
    focus: true
    height: 600
    padding: 10
    width: 400

    background: Rectangle {
        anchors.fill: parent
        border.color: palette.alternateBase
        color: palette.window
        radius: 20
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 5

        RowLayout {
            Layout.fillWidth: true
            Layout.preferredHeight: 1

            TextField {
                Layout.fillHeight: true
                Layout.fillWidth: true
                color: palette.buttonText
                placeholderText: "Type a note and press enter"

                background: Rectangle {
                    border.color: annotationSearch.activeFocus ? palette.highlight : palette.alternateBase
                    color: annotationSearch.enabled ? "transparent" : palette.button
                    radius: 10
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

                        onClicked:
                        // kaeLib.copyToClipboard(modelData);
                        // kaeLib.showToast("Copied to clipboard");
                        {
                        }
                    }
                }
            }
        }
    }
}
