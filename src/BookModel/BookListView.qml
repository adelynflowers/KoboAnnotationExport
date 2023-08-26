import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Basic
import QtQuick.Dialogs
import BookModelLib

ListView {
    id: bookContainer

    property var collapsed: ({})
    property variant highlightColors: (["#50723c", "#773344", "#f1c40f"])
    property variant highlightWeights: ([2, 3, 5])
    property var notColors: (["red", "green", "blue"])
    property bool sectionsEnabled: true

    function addColor(index, color) {
        bookModel.addAnnotationColor(index, color);
    }
    function collapseSection(section) {
        collapsed[section] = true;
        collapsedChanged();
    }
    function expandSection(section) {
        delete collapsed[section];
        collapsedChanged();
    }
    function getHighlightColors() {
        return ["#50723C", "#773344", "#F1C40F"];
    }
    function getHighlightWeights() {
        return [2, 3, 5];
    }
    function isExpanded(section) {
        return !(section in collapsed);
    }
    function openApplicationDB(filename) {
        if (bookModel.openApplicationDB(filename)) {
            bookModel.selectAll();
        }
    }
    function openKoboDB(filename) {
        return bookModel.openKoboDB(filename);
    }
    function removeColor(index, color) {
        bookModel.removeAnnotationColor(index, color);
    }
    function searchAnnotations(query) {
        bookModel.searchAnnotations(query);
    }
    function sortByDate(descending) {
        bookModel.sortByDate(descending);
    }
    function toggleFilterOnColor(filterColor) {
        let filterIdx = -1;
        for (let i = 0; i < highlightColors.length; i++) {
            if (filterColor == highlightColors[i]) {
                filterIdx = i;
                break;
            }
        }
        let weight = highlightWeights[filterIdx];
        bookModel.toggleFilterOnColor(weight);
    }
    function toggleSection(section) {
        if (isExpanded(section)) {
            collapseSection(section);
        } else {
            expandSection(section);
        }
    }
    function toggleSectionsVisibility() {
        sectionsEnabled = !sectionsEnabled;
    }

    boundsBehavior: Flickable.StopAtBounds
    clip: true
    currentIndex: -1
    focus: true
    highlightMoveVelocity: 5000
    model: bookModel.getProxyModel()
    section.property: "title"
    spacing: 0

    delegate: BookModelDelegate {
    }

    BookModel {
        id: bookModel

    }
    section {
        criteria: ViewSection.FullString

        delegate: Label {
            signal clicked

            font.family: "fontello"
            font.pixelSize: 24
            height: ListView.view.sectionsEnabled ? implicitHeight + 20 : 0
            horizontalAlignment: Text.AlignLeft
            text: ListView.view.sectionsEnabled ? (ListView.view.isExpanded(section) ? "\uE800 " : "\uE801 ") + section : ""
            verticalAlignment: Text.AlignBottom

            Behavior on height {
                NumberAnimation {
                    duration: 200
                }
            }

            //TODO: figure out bottom margin
            onClicked: ListView.view.toggleSection(section)

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor

                onClicked: {
                    parent.clicked();
                }
            }
        }
    }
}
