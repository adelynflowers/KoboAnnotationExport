import QtQuick 
import QtQuick.Dialogs
import QtQuick.Layouts
//import QtQuick.Controls
import QtQuick.Controls.Basic
import BookListLib


ApplicationWindow {
    visible: true
    width: 1280
    height: 720
    palette: KaeDarkPalette{}
    ToastManager {
        id: toast
        width: 150
        height: childrenRect.height
        Connections {
            target: kaeLib 
            function onToastReceived(message) {
                toast.show(message, 1000);
            }
        }
    }
    header: ToolBar {
        height: parent.height * 0.1
        RowLayout {
            spacing: 6
            anchors.fill: parent
            ColumnLayout {
                Layout.preferredWidth: 4
                Layout.fillHeight: true
                Label {
                    text: "Kae"
                    font.pixelSize: 24
                    color: palette.buttonText
                    Layout.leftMargin: 10
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    verticalAlignment: Qt.AlignVCenter
                }
            }
            RowLayout {
                Layout.preferredWidth: 6
                Layout.fillHeight: true
                Switch {
                    id: control
                    text: qsTr("Grouped")
                    checked: bookList.sectionsEnabled
                    onToggled: {
                        bookList.toggleSectionsVisibility()
                        kaeLib.showToast("Toggled groups")
                    }
                    indicator: Rectangle {
                        implicitWidth: 48
                        implicitHeight: 13
                        x: control.leftPadding
                        y: parent.height / 2 - height / 2
                        radius: 13
                        color: control.checked ? palette.highlight : palette.buttonText
                        border.color: color

                        Rectangle {
                            x: control.checked ? parent.width - width : 0
                            anchors.verticalCenter: parent.verticalCenter
                            width: 26
                            height: 26
                            radius: 13
                            color: control.down ? "#cccccc" : "#ffffff"
                            border.color: "#999999"
                            Behavior on x {
                                NumberAnimation {duration:100}
                            }
                        }
                    }

                    contentItem: Text {
                        text: control.text
                        font: control.font
                        opacity: enabled ? 1.0 : 0.3
                        color: palette.buttonText
                        verticalAlignment: Text.AlignVCenter
                        leftPadding: control.indicator.width + control.spacing
                    }
                }
                RowLayout {
                    Layout.fillWidth: true 
                    Layout.fillHeight: true
                    TextField {
                        id: annotationSearch
                        Layout.fillWidth: true 
                        Layout.fillHeight: false
                        Layout.leftMargin: 0
                        Layout.rightMargin: 20
                        leftPadding: 20
                        clip: true
                        color: palette.buttonText
                        background: Rectangle {
                            radius: 50
                            color: annotationSearch.enabled ? "transparent" : palette.button
                            border.color: annotationSearch.activeFocus ? palette.highlight : palette.alternateBase
                        }
                        placeholderText: qsTr("Type to begin searching")
                        onTextEdited: function() {
                            bookList.searchAnnotations(annotationSearch.text)
                        }
                        Label {
                            text: "\uE802"
                            color: palette.buttonText
                            font.family: "fontello"
                            anchors.left: parent.left
                            anchors.leftMargin: 5
                            anchors.verticalCenter: parent.verticalCenter
                        }
                    }
                }
            }
        }
    }
    ColumnLayout {
        anchors.fill: parent
        //Content Row
        RowLayout {
            Layout.fillWidth: true 
            Layout.preferredHeight: 8
            BookListView {
                id: bookList
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.leftMargin: 5
                Layout.rightMargin: 5
                Connections {
                    target: kaeLib 
                    function onAppReady(filename) {
                        bookListLoad.running = true
                        bookList.openApplicationDB(filename);
                        bookListLoad.running = false
                    }
                }
                BusyIndicator {
                    id: bookListLoad
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                }
            }
        }
    }

    MessageDialog {
        id: detectionDialog
        text: qsTr("Device detected")
        informativeText: qsTr("A Kobo device has been detected, extract annotations?")
        property string detectedPath;
        buttons: MessageDialog.Yes | MessageDialog.No
        onButtonClicked: function (button, role) {
            if (button == MessageDialog.Yes) {
                acceptDevice();
            } else {
                rejectDevice();
            }
        }
        onAccepted: acceptDevice()
        onRejected: rejectDevice()
        Connections {
            target: kaeLib 
            function onDeviceDetected(dbPath) {
                if (!detectionDialog.visible) {
                    detectionDialog.detectedPath = dbPath;
                    detectionDialog.open();
                }
            }
        }

        function acceptDevice() {
            let detectedPath = detectionDialog.detectedPath
            bookListLoad.running = true 
            let success = bookList.openKoboDB(detectedPath);
            bookListLoad.running = false
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
        
    }
}
    
