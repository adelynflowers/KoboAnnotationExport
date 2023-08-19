import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import com.kae.NestedListModelLib 1.0

ApplicationWindow {
    width: 1280
    height: 720
    visible: true

    ColumnLayout {
        anchors.fill: parent
        Rectangle {
            Layout.preferredWidth: 2
            Layout.preferredHeight: 2
            Layout.alignment: Qt.AlignHCenter
            color: "red"
        }
        ListView {
            id: outerList
            Layout.alignment: Qt.AlignHCenter
            Layout.preferredHeight: 2
            Layout.preferredWidth: 2
            model: NestedListViewModel {}
            spacing: 5
            delegate: Column {          
                height: topLabel.height + subList.height
                width: ListView.view.width  
                anchors.verticalCenter: ListView.view.verticalCenter

                TapHandler {
                    onTapped: {
                        subList.height = subList.height > 0 ? -1 : subList.contentHeight
                        subList.width = subList.width > 0 ? -1 : subList.contentWidth

                    }
                }
                Row {
                    Label {
                        text: "▸"
                        rotation: subList.width > 0 ? 90 : 0
                    }
                    Label {
                        id: topLabel
                        text: title
                    }
                }
                Repeater {
                    id: subList
                    model: submodel
                    // contentWidth: parent.width
                    // height: contentHeight
                    // width: contentWidth
                    delegate: Label {
                        id: subLabel
                        text: model.annotation
                        Component.onCompleted: {
                            console.log(model.annotation);
                            console.log(subList.contentHeight, subList.contentWidth);
                            console.log(subList.height, subList.width);
                            console.log(subLabel.implicitHeight, subLabel.implicitWidth);
                            console.log(subLabel.height, subLabel.width);
                        }
                    }
                        
                }
            }
        }
    }
}
