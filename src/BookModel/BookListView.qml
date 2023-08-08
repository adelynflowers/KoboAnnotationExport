import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import BookModelLib

ListView {
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
    
    onFileNameChanged: {
        console.log("BookList file changed");
        bookModel.openDB(fileName)
    }

    function extract() {
        console.log("Extract request received")
        bookModel.findAttachedDB();
    }

}
