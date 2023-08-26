import QtQuick
import QtQuick.Controls.Basic

/*
A round button with a contrasting border and icon center. The border
is made visible on hover, and the button is styled as a traditional button
on click.
 */
Button {
    id: baseBtn

    property bool buttonHovered: subMouseArea.containsMouse

    font.family: "fontello"
    height: implicitHeight + 5
    hoverEnabled: true
    width: implicitWidth + 5

    background: Rectangle {
        anchors.fill: parent
        border.color: palette.button
        border.width: 2
        color: "transparent"
        opacity: subMouseArea.containsMouse ? 1 : 0
        radius: 500

        Rectangle {
            anchors.fill: parent
            color: palette.button
            opacity: baseBtn.pressed ? 1 : 0
            radius: parent.radius
        }
        MouseArea {
            id: subMouseArea

            anchors.fill: parent
            hoverEnabled: true
        }
    }
    contentItem: Text {
        color: parent.pressed ? palette.buttonText : palette.windowText
        elide: Text.ElideRight
        font: parent.font
        horizontalAlignment: Text.AlignHCenter
        opacity: enabled ? 1.0 : 0.3
        text: parent.text
        verticalAlignment: Text.AlignVCenter
    }
    Behavior on opacity {
        NumberAnimation {
            duration: 200
        }
    }
}
