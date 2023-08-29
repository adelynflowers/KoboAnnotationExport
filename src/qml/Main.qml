import QtQuick
import QtCore
import QtQuick.Dialogs
import QtQuick.Layouts
//import QtQuick.Controls
import QtQuick.Controls.Basic
import BookListLib

ApplicationWindow {
    height: 720
    visible: true
    width: 1280

    header: ToolBar {
        height: parent.height * 0.1

        RowLayout {
            anchors.fill: parent
            spacing: 6

            ColumnLayout {
                Layout.fillHeight: true
                Layout.preferredWidth: 4

                Label {
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    Layout.leftMargin: 10
                    color: palette.buttonText
                    font.pixelSize: 24
                    text: "Kae"
                    verticalAlignment: Qt.AlignVCenter
                }
            }
            RowLayout {
                Layout.fillHeight: true
                Layout.preferredWidth: 6
                Button {
                    id: exportBtn
                    text: qsTr("Export")
                    onClicked: exportDialog.open()

                    FolderDialog {
                        id: exportDialog
                        currentFolder:StandardPaths.writableLocation(StandardPaths.DownloadLocation)
                        onAccepted: {
                            bookList.exportAnnotations(selectedFolder)
                            kaeLib.showToast("Wrote annotations to "+(selectedFolder+"/"+"koboAnnotations.csv"))
                        }
                        acceptLabel: "Save"
                    }
                }

                Switch {
                    id: control

                    checked: bookList.sectionsEnabled
                    text: qsTr("Grouped")

                    contentItem: Text {
                        color: palette.buttonText
                        font: control.font
                        leftPadding: control.indicator.width + control.spacing
                        opacity: enabled ? 1.0 : 0.3
                        text: control.text
                        verticalAlignment: Text.AlignVCenter
                    }
                    indicator: Rectangle {
                        border.color: color
                        color: control.checked ? palette.highlight : palette.buttonText
                        implicitHeight: 13
                        implicitWidth: 48
                        radius: 13
                        x: control.leftPadding
                        y: parent.height / 2 - height / 2

                        Rectangle {
                            anchors.verticalCenter: parent.verticalCenter
                            border.color: "#999999"
                            color: control.down ? "#cccccc" : "#ffffff"
                            height: 26
                            radius: 13
                            width: 26
                            x: control.checked ? parent.width - width : 0

                            Behavior on x {
                                NumberAnimation {
                                    duration: 100
                                }
                            }
                        }
                    }

                    onToggled: {
                        bookList.toggleSectionsVisibility();
                        kaeLib.showToast("Toggled groups");
                    }
                }
                RowLayout {
                    Layout.fillHeight: true
                    Layout.fillWidth: true

                    TextField {
                        id: annotationSearch

                        Layout.fillHeight: false
                        Layout.fillWidth: true
                        Layout.leftMargin: 0
                        Layout.rightMargin: 20
                        clip: true
                        color: palette.buttonText
                        leftPadding: 20
                        placeholderText: qsTr("Type to begin searching")

                        background: Rectangle {
                            border.color: annotationSearch.activeFocus ? palette.highlight : palette.alternateBase
                            color: annotationSearch.enabled ? "transparent" : palette.button
                            radius: 50
                        }

                        onTextEdited: function () {
                            bookList.searchAnnotations(annotationSearch.text);
                        }

                        Label {
                            anchors.left: parent.left
                            anchors.leftMargin: 5
                            anchors.verticalCenter: parent.verticalCenter
                            color: palette.buttonText
                            font.family: "fontello"
                            text: "\uE802"
                        }
                    }
                }
            }
        }
    }
    palette: KaeDarkPalette {
    }

    ToastManager {
        id: toast

        height: childrenRect.height
        width: 150

        Connections {
            function onToastReceived(message) {
                toast.show(message, 1000);
            }

            target: kaeLib
        }
    }
    ColumnLayout {
        anchors.fill: parent

        RowLayout {
            Layout.fillWidth: true
            Layout.preferredHeight: 1

            Item {
                Layout.fillHeight: false
                // Spacer
                Layout.fillWidth: true
            }
            Repeater {
                Layout.fillHeight: true
                Layout.fillWidth: true
                model: bookList.getHighlightColors()

                Rectangle {
                    property bool selected: false

                    border.color: (subMouseArea.containsMouse || selected) ? palette.windowText : "transparent"
                    color: modelData
                    height: 15
                    opacity: (subMouseArea.containsMouse || selected) ? 1 : 0.3
                    radius: 50
                    width: 15

                    MouseArea {
                        id: subMouseArea

                        anchors.fill: parent
                        hoverEnabled: true

                        onClicked: {
                            parent.selected = !selected;
                            bookList.toggleFilterOnColor(parent.color);
                        }
                    }
                }
            }
            Button {
                id: sortButton

                Layout.fillHeight: false
                Layout.fillWidth: false
                flat: true
                font.family: "fontello"
                text: "\uF161"

                onClicked: sortMenu.open()

                Menu {
                    id: sortMenu

                    rightMargin: sortButton.width / 2
                    y: sortButton.height

                    MenuItem {
                        font.family: "fontello"
                        text: "\uF161 Date (desc)"

                        onClicked: bookList.sortByDate(true)
                    }
                    MenuItem {
                        font.family: "fontello"
                        text: "\uF160 Date (asc)"

                        onClicked: bookList.sortByDate(false)
                    }
                }
            }
        }
        //Content Row
        RowLayout {
            Layout.fillWidth: true
            Layout.preferredHeight: 9

            BookListView {
                id: bookList

                Layout.fillHeight: true
                Layout.fillWidth: true
                Layout.leftMargin: 150
                Layout.rightMargin: 150

                Connections {
                    function onAppReady(filename) {
                        bookListLoad.running = true;
                        bookList.openApplicationDB(filename);
                        bookListLoad.running = false;
                    }

                    target: kaeLib
                }
                BusyIndicator {
                    id: bookListLoad
                    running: false
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                }
            }
        }
    }
    MessageDialog {
        id: detectionDialog

        property string detectedPath

        function acceptDevice() {
            let detectedPath = detectionDialog.detectedPath;
            bookListLoad.running = true;
            let success = bookList.openKoboDB(detectedPath);
            bookListLoad.running = false;
            if (success) {
                console.log("Successfully opened DB at ", detectedPath);
                kaeLib.currentDevice = detectedPath;
            } else {
                console.log("Failed to open DB at ", detectedPath, ". blacklisting");
                //TODO: Better way to handle failure
                kaeLib.blacklistDevice(detectedPath);
            }
        }
        function rejectDevice() {
            // No is an explicit blacklist
            console.log("Blacklisting device ", detectedPath);
            kaeLib.blacklistDevice(detectedPath);
        }

        buttons: MessageDialog.Yes | MessageDialog.No
        informativeText: qsTr("A Kobo device has been detected, extract annotations?")
        text: qsTr("Device detected")

        onAccepted: acceptDevice()
        onButtonClicked: function (button, role) {
            if (button == MessageDialog.Yes) {
                acceptDevice();
            } else {
                rejectDevice();
            }
        }
        onRejected: rejectDevice()

        Connections {
            function onDeviceDetected(dbPath) {
                if (!detectionDialog.visible) {
                    detectionDialog.detectedPath = dbPath;
                    detectionDialog.open();
                }
            }

            target: kaeLib
        }
    }
}
