import QtQuick 2.12
import QtQuick.Window 2.12
import QtQml.Models 2.3
import QtQuick.Templates 2.5



Window {
    id: mainWindow
    width: Screen.width / 1.3
    height: Screen.height / 1.3
    visible: true
    title: qsTr("Hive")
    property string backgroungColor: "#A8B0E6"

    GameBoard {
        id: gameBoard
        anchors.fill: parent
    }

    GameInterface {
        id: gameInterface
        anchors.fill: parent
        currentTurn: gameBoard.currentTurn
    }

    Component.onCompleted: {
        gameBoard.sideLong = height/23
        gameBoard.addEmptyHexagon(width, height, gameBoard.sideLong)
    }
}
