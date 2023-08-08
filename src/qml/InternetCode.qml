import QtQuick 
import QtQuick.Window 
import QtQml.Models 
import QtQuick.Controls 
import QtQuick.Layouts
 
Window {
    visible: true
 
    width: 200
    height: 480
    color: "cyan"
 
    ListModel {
        id: fruitModel
 
        ListElement {
            name: "Apple"
        }
        ListElement {
            name: "Orange"
        }
    }
 
    Component {
        id: delegateComp
 
        RowLayout
        {
            width: parent.width
 
            Text {
                id: malzemeresultxt
                font.pixelSize: 15
                text: name
                wrapMode: Text.Wrap
                Layout.fillWidth: true
                //Layout.maximumWidth: parent.width - 17
            }
 
            Rectangle {
                id: maldeleteimg
                width: 10
                height: 10
                color: "red"
                Layout.alignment: Qt.AlignRight
            }
        }
    }
 
    ListView {
        id:malzemelist
 
        anchors {
            top: parent.top
            bottom: button.top; bottomMargin: 10
            left: parent.left
            right: parent.right
        }
 
        spacing: 6
        clip:true
        orientation:ListView.Vertical
        flickableDirection: Flickable.VerticalFlick
        boundsBehavior: Flickable.StopAtBounds
        model: fruitModel
        delegate: delegateComp
    }
 
    Button {
        id: button
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        text: "add fruit with a long name"
 
        onClicked: {
            fruitModel.append({ name: "Banananananananananananananananananananananana" })
        }
    }
}