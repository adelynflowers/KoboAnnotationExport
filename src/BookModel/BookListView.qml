import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Dialogs
import BookModelLib



ListView {
    id: bookContainer
    spacing: 5
    BookModel {
        id: bookModel
    }
    model: bookModel.getProxyModel()
    delegate: BookModelDelegate {}
    highlightMoveVelocity: 5000
    clip: true 
    boundsBehavior: Flickable.StopAtBounds
    focus: true
    currentIndex: -1

    function openKoboDB(filename) {
        console.log("Opening DB", filename)
        return bookModel.openKoboDB(filename);
        
    }

    function openApplicationDB(filename) {
        console.log("Opening app DB, ", filename)
        if (bookModel.openApplicationDB(filename)) {
            bookModel.selectAll();
        }
    }

    function searchAnnotations(query) {
        console.log("Searching annotations for ", query);
        bookModel.searchAnnotations(query);
    }
    SystemPalette {
        id: palette
        colorGroup: SystemPalette.Active
    }
    Rectangle {
        anchors.fill: parent
        z: -1
        color: palette.alternateBase
    }
}
