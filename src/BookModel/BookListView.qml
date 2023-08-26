import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Basic
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
    property bool sectionsEnabled: true

    section {
        property: "title"
        criteria: ViewSection.FullString
        delegate: Label {
            height: ListView.view.sectionsEnabled ? implicitHeight + 20 : 0
            signal clicked()
            text: ListView.view.sectionsEnabled ? (
                ListView.view.isExpanded(section) ? "\uE800 " : "\uE801 " 
             ) + section : ""
            font.pixelSize: 24
            font.family: "fontello"
            horizontalAlignment: Text.AlignLeft 
            verticalAlignment: Text.AlignBottom
            Behavior on height {
                NumberAnimation{duration: 200}
            }
            //TODO: figure out bottom margin
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
    function toggleSectionsVisibility() {
        sectionsEnabled = !sectionsEnabled;
    }

    function addColor(index, color) {
        bookModel.addAnnotationColor(index, color);
    }
    function removeColor(index, color) {
        bookModel.removeAnnotationColor(index, color);
    }

    function sortByDate(descending) {
        bookModel.sortByDate(descending);
    }
}
