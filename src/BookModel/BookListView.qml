import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Dialogs
import BookModelLib

ListView {
    id: bookContainer
    spacing: -1
    model: BookModel {
        id: bookModel
    }
    delegate: BookModelDelegate {}
    highlight: Rectangle {
        color: 'grey'
    }
    highlightMoveVelocity: 5000
    clip: true 
    boundsBehavior: Flickable.StopAtBounds
    focus: true
    currentIndex: -1
    property url fileName
    property url detectedUrl
    
    onFileNameChanged: {
        console.log("BookList file changed");
        bookModel.openDB(fileName)
    }
    Connections {
        target: bookModel 
        function onDeviceDetected(url) {
            bookContainer.detectedUrl = url
            detectionDialog.open()
        }
    }
    MessageDialog {
        id: detectionDialog
        text: qsTr("A Kobo device has been detected, extract annotations?")
        buttons: MessageDialog.Yes | MessageDialog.No
        onButtonClicked: function (button, role) {
            switch (button) {
            case MessageDialog.Yes:
                bookModel.openDB(bookContainer.detectedUrl);
                break;
            case MessageDialog.No:
                bookModel.blacklistDevice(bookContainer.detectedUrl);
                break;
            }
        }
        
    }

    function extract() {
        console.log("Extract request received")
        bookModel.openAttachedDB();
    }

}
