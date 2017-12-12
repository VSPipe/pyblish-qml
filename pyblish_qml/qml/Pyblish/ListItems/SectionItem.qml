import QtQuick 2.0
import Pyblish 0.1


Item {
    id: root

    height: 22
    width: parent.width

    property var object: {"isHidden": false}

    property bool checkState: true
    property bool hideState: object.isHidden
    property string text

    property var statuses: {
        "default": "gray",
        "processing": Theme.primaryColor,
        "success": "gray",
        "warning": Theme.dark.warningColor,
        "error": Theme.dark.errorColor
    }

    property string status: {
        if (object.isProcessing)
            return "processing"
        if (object.hasError)
            return "error"
        if (object.hasWarning)
            return "warning"
        if (object.succeeded)
            return "success"
        return "default"
    }

    signal labelClicked
    signal sectionClicked

    Rectangle {
        anchors.fill: parent
        color: Theme.alpha("#000", 0.4)
        opacity: status == "processing" ? 1.0 : 0
        radius: 3

        Rectangle {
            anchors.fill: parent
            color: "transparent"
            border.color: "white"
            border.width: 1
            radius: 3
            visible: status == "processing" ? 1 : 0

            SequentialAnimation on opacity {
                running: true

                NumberAnimation {
                    from: .4
                    to: 1
                    duration: 800
                    easing.type: Easing.InOutElastic
                }
                NumberAnimation {
                    from: 1
                    to: .4
                    duration: 800
                    easing.type: Easing.InOutElastic
                }

                loops: Animation.Infinite
            }
        }
    }

    Rectangle {
        color: "#333"
        border.width: 1
        border.color: statuses[status]
        anchors.fill: parent
        anchors.margins: 2
        opacity: 0.5

        Rectangle {
            color: "transparent"
            border.width: 1
            border.color: "#383838"
            anchors.fill: parent
            anchors.margins: 1
        }
    }

    Rectangle {
        id: iconBackground
        anchors.fill: parent
        anchors.margins: 3
        anchors.rightMargin: parent.width - height - 2
        color: statuses[status]
        opacity: ma.containsPress ? 0.9 :
                 ma.containsMouse ? 0.7 : 0.4
    }

    Rectangle {
        id: labelBackground
        anchors.fill: parent
        anchors.margins: 3
        anchors.leftMargin: height + 2
        opacity: labelMa.containsPress ? 0.15 :
                 labelMa.containsMouse ? 0.10 : 0
    }

    AwesomeIcon {
        name: "minus"
        opacity: !root.hideState ? 0.7: 0
        anchors.verticalCenter: iconBackground.verticalCenter
        anchors.horizontalCenter: iconBackground.horizontalCenter

        size: 9
    }

    AwesomeIcon {
        name: "plus"
        opacity: root.hideState ? 0.7: 0
        anchors.verticalCenter: iconBackground.verticalCenter
        anchors.horizontalCenter: iconBackground.horizontalCenter

        size: 9
    }

    Label {
        id: label
        text: root.text
        opacity: 0.5
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: iconBackground.right
        anchors.leftMargin: 5
    }

    MouseArea {
        id: ma
        anchors.fill: iconBackground
        hoverEnabled: true
        onClicked: root.sectionClicked()
    }

    MouseArea {
        id: labelMa
        anchors.fill: labelBackground
        hoverEnabled: true
        onClicked: root.labelClicked()
    }
}
