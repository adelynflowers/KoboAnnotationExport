import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Basic
import QtQuick.Dialogs
import BookModelLib

/*
Displays books in a list view. Provides a myriad of functions to
filter on colors, annotation text, book titles, and dates.
 */
ListView {
    id: bookContainer

    // list of sections that are currently collapsed
    property var collapsed: ({})
    // colors used for highlighting annotations
    property variant highlightColors: (["#50723c", "#773344", "#f1c40f"])
    // weights used for calculating highlights
    property variant highlightWeights: ([2, 3, 5])
    // flag for enabling section headers
    property bool sectionsEnabled: true

    // Add a highlight color to the model at a given index
    function addColor(index, color) {
        bookModel.addAnnotationColor(index, color);
    }

    // Collapse a book section
    function collapseSection(section) {
        collapsed[section] = true;
        collapsedChanged();
    }

    // Expand a book section
    function expandSection(section) {
        delete collapsed[section];
        collapsedChanged();
    }

    // Get the list of highlight colors
    function getHighlightColors() {
        return ["#50723C", "#773344", "#F1C40F"];
    }

    // Get the list of highlight weights
    function getHighlightWeights() {
        return [2, 3, 5];
    }

    // Returns if section is expanded
    function isExpanded(section) {
        return !(section in collapsed);
    }

    // Opens the application DB located at filename and
    // populates the model with its data
    function openApplicationDB(filename) {
        if (bookModel.openApplicationDB(filename)) {
            bookModel.selectAll();
        }
    }

    // Opens a kobo DB at filename, and adds its data
    // to the app DB and the current model
    function openKoboDB(filename) {
        return bookModel.openKoboDB(filename);
    }

    // Remove a highlight color from an annotation
    function removeColor(index, color) {
        bookModel.removeAnnotationColor(index, color);
    }

    // Filter the model to annotations matching the query string
    function searchAnnotations(query) {
        bookModel.searchAnnotations(query);
    }

    // Sort the model by date
    function sortByDate(descending) {
        // TODO: Fix duplication
        bookModel.sortByDate(descending);
        print(bookModel)
    }

    // Filter the model for annotations highlighted with filterColor
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

    // Toggles a sections collapsed status
    function toggleSection(section) {
        if (isExpanded(section)) {
            collapseSection(section);
        } else {
            expandSection(section);
        }
    }

    // Toggles a sections visibility
    function toggleSectionsVisibility() {
        sectionsEnabled = !sectionsEnabled;
    }

    // Pushes UI changes to the app DB
    function exportAnnotations(location) {
        bookModel.updateRows();
        var urlObject = new URL(location);
        bookModel.exportAnnotations(urlObject.pathname);
    }
    function updateNoteString(row, string) {
        bookModel.updateNoteString(row, string);
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

        delegate: BookSectionDelegate {
        }
    }

    NotesPopup {
        id: notesPopup
    }

    Connections {
        function onClosed() {
            let resultingNoteString = notesPopup.getNoteString();
            let openingIndex = notesPopup.getOpeningIndex();
            if (resultingNoteString !== model.notes) {
                updateNoteString(openingIndex, resultingNoteString);
            }
        }

        target: notesPopup
    }
}
