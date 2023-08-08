import QtQuick 
import QtQuick.Layouts
import QtQuick.Controls

ApplicationWindow {
    visible: true
    width: 1280
    height: 720
    // RowLayout {
    //     anchors.fill: parent
    //     // Label {
    //     //     text: "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaAA"
    //     //     Layout.fillWidth: true
    //     //     wrapMode: Text.Wrap
    //     // }
    //     ListView {
    //         id: listView
    //         Layout.fillWidth: true
    //         Layout.fillHeight: true 
    //         model: ListModel {
    //             ListElement {
    //                 name: "Bill Smith"
    //                 number: "555 3264"
    //             }
    //             ListElement {
    //                 name: "John Brown"
    //                 number: "555 8426"
    //             }
    //             ListElement {
    //                 name: "Sam Wise"
    //                 number: "555 0473"
    //             }
    //         }
    //         delegate: 
    //             Label {
    //                 text: name + ": " + number
    //                 width: ListView.view.width
    //                 wrapMode: Text.Wrap
    //             }
            
    //     }
    // }
    StackView {
        id: stackView 
        anchors.fill: parent 
        initialItem: First {}
        onCurrentItemChanged: {
            currentItem.forceActiveFocus()
        }
    }
    // For dark mode/light mode coloring
    // SystemPalette {
    //     id: myPalette
    //     colorGroup: SystemPalette.Active
    // }
    // property color system_text_color: myPalette.text
}