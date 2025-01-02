import QtQuick 2.12
import QtQuick.Window 2.12
import QtQml.Models 2.3
import QtQuick.Templates 2.5

Item{
    id: gameInterface
    property int currentTurn

    SideGamePanel{
        myTurn: currentTurn % 2 == 1

        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: 20
    }
    SideGamePanel{
        myTurn: currentTurn % 2 == 0

        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right
        anchors.rightMargin: 20
        isRight: true
        isBlack: true
    }
}
