import QtQuick 
import Qt.labs.platform
import QtQuick.Layouts
import QtQuick.Controls
import BookListLib

ApplicationWindow {
    visible: true
    width: 1280
    height: 720
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
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    verticalAlignment: Qt.AlignVCenter
                }
            }
            RowLayout {
                Layout.preferredWidth: 6
                Layout.fillHeight: true
                ToolButton {
                    text: qsTr("Extract")
                    font.pixelSize: 24
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                }
                ToolButton {
                    text: qsTr("Sync")
                    font.pixelSize: 24
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                }
                ToolButton {
                    text: qsTr("Settings")
                    font.pixelSize: 24
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    onClicked: kaeLib.hello()
                }
                TextField {
                    id: annotationSearch
                    Layout.fillWidth: true 
                    Layout.fillHeight: false
                    clip: true
                    placeholderText: qsTr("Type to begin searching")
                    onTextEdited: function() {
                        bookList.searchAnnotations(annotationSearch.text)
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
        onYesClicked: {
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
        onNoClicked: {
            // No is an explicit blacklist
            console.log("Blacklisting device ", detectedPath);
            kaeLib.blacklistDevice(detectedPath);
        }
        Connections {
            target: kaeLib 
            function onDeviceDetected(dbPath) {
            if (!detectionDialog.visible) {
                detectionDialog.detectedPath = dbPath;
                detectionDialog.open();
            }
        }
        }
        
    }
}
    
