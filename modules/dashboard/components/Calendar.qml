pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls

import "../../../widgets"
import "../../../config"

// stolen from Caelestia
Column {
    id: root

    anchors.left: parent.left
    anchors.right: parent.right
    padding: Config.spacing.normal
    spacing: Config.spacing.small

    DayOfWeekRow {
        id: days

        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: parent.padding

        locale: Qt.locale("en_GB")

        delegate: CustomText {
            required property var model

            horizontalAlignment: Text.AlignHCenter
            text: model.shortName
            font.weight: 500
        }
    }

    MonthGrid {
        id: grid

        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: parent.padding

        spacing: 3

        delegate: Item {
            id: day

            required property var model

            implicitWidth: implicitHeight
            implicitHeight: text.implicitHeight + Config.spacing.small * 2

            CustomRect {
                anchors.centerIn: parent

                implicitWidth: parent.implicitHeight
                implicitHeight: parent.implicitHeight

                radius: Config.radius.small
                color: model.today ? Colors.current.primary : "transparent"

                CustomText {
                    id: text

                    anchors.centerIn: parent

                    horizontalAlignment: Text.AlignHCenter
                    text: Qt.formatDate(day.model.date, "d")
                    color: day.model.today ? Colors.current.on_primary : day.model.month === grid.month ? Colors.current.on_background : Colors.current.outline
                }
            }
        }
    }
}
