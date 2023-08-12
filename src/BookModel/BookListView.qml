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

    function openDB(filename) {
        console.log("Opening DB", filename)
        return bookModel.openDB(filename);
        
    }
}
