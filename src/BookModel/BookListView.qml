import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Dialogs
import BookModelLib



ListView {
    id: bookContainer
    spacing: 0
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
    property var collapsed: ({})

    section {
        property: "title"
        criteria: ViewSection.FullString
        delegate: Label {
            height: implicitHeight + 20
            signal clicked()
            text: (
                ListView.view.isExpanded(section) ? "\uE800 " : "\uE801 " 
             ) + section
            font.pixelSize: 24
            font.family: "fontello"
            horizontalAlignment: Text.AlignLeft 
            verticalAlignment: Text.AlignBottom
            //TODO: Figure out bottom margin
            onClicked: ListView.view.toggleSection(section)
            MouseArea {
                anchors.fill: parent 
                onClicked: {
                    parent.clicked()
                }
                cursorShape: Qt.PointingHandCursor

            }
        }
    }

    function openKoboDB(filename) {
        return bookModel.openKoboDB(filename);
        
    }

    function openApplicationDB(filename) {
        if (bookModel.openApplicationDB(filename)) {
            bookModel.selectAll();
        }
    }

    function searchAnnotations(query) {
        bookModel.searchAnnotations(query);
    }
    SystemPalette {
        id: palette
        colorGroup: SystemPalette.Active
    }
    // Rectangle {
    //     anchors.fill: parent
    //     z: -1
    //     color: palette.alternateBase
    // }

    function isExpanded(section) {
        return !(section in collapsed)
    }
    function expandSection(section) {
        delete collapsed[section]
        collapsedChanged()
    } 
    function collapseSection(section) {
        collapsed[section] = true 
        collapsedChanged()
    }
    function toggleSection(section) {
        if (isExpanded(section)) {
            collapseSection(section)
        }
        else {
            expandSection(section)
        }
    }
}
