import QtQuick 2.12
import QtQuick.Window 2.12
import QtQml.Models 2.3
import QtQuick.Templates 2.5

Rectangle{
    id: panel
    property bool isBlack: false
    property int shakingStep: 6
    property bool isRight: false
    property bool panelContainsMouse: false

    property bool myTurn

    enabled: myTurn

    property string checkedInsectType: ""

    onCheckedInsectTypeChanged: gameBoard.currentInsectType = [checkedInsectType, isBlack]

    Connections{ target: gameBoard; onOffSellChoiceMode: panel.checkedInsectType = ""}
    clip: true

    radius: 20
    border.width: 3
    color: Qt.rgba(0,0,0,0.3)
    border.color: "grey"

    width: gameInterface.width / 11
    height: Math.sin(Math.PI / 3) * (panel.width / 3.32) * 8 * 2.75 + 40 > mainWindow.height? mainWindow.height : Math.sin(Math.PI / 3) * (panel.width / 3.32) * 8 * 2.75 + 40

    function reduceInsect(insectType){
        for(var i = 0; i < set.count; i++){
            if(set.get(i)._insectType === insectType){
                set.setProperty(i,"_insectTypeCount", set.get(i)._insectTypeCount - 1)
                break
            }
        }
    }

    ListModel{
        id: set
        ListElement{
            _insectType: "bee"
            _insectTypeCount: 1
        }
        ListElement{
            _insectType: "ant"
            _insectTypeCount: 3
        }
        ListElement{
            _insectType: "grasshoper"
            _insectTypeCount: 3
        }
        ListElement{
            _insectType: "bug"
            _insectTypeCount: 2
        }
        ListElement{
            _insectType: "spider"
            _insectTypeCount: 2
        }
        ListElement{
            _insectType: "gnat"
            _insectTypeCount: 1
        }
        ListElement{
            _insectType: "ladybug"
            _insectTypeCount: 1
        }
        ListElement{
            _insectType: "pillbug"
            _insectTypeCount: 1
        }
    }

    Column{
        anchors.verticalCenter: parent.verticalCenter
        anchors{
            left: panel.isRight? panel.left : undefined
            right: !panel.isRight? panel.right : undefined
            margins: panel.width / 2 - panel.width / 3.32
        }

        anchors.verticalCenterOffset: spacing * 2.5
        spacing: Math.sin(Math.PI / 3) * (panel.width / 3.32) / 2
        Repeater{
            model: set
            delegate: Row{
                id: row
                anchors.right: !panel.isRight? parent.right : undefined
                anchors.left: panel.isRight? parent.left : undefined
                layoutDirection: panel.isRight? "RightToLeft" : "LeftToRight"
                anchors.margins: 0

                Connections{
                    target: gameBoard
                    function onCutBack(insectType, isBlack){
                        if(_insectType === insectType && panel.isBlack === isBlack){
                            reduceInsect(insectType)
                            if(_insectTypeCount > 0)
                                marginAnimation.start()
                        }
                    }
                }

                NumberAnimation {
                    id: marginAnimation
                    target: row
                    property: "anchors.margins"
                    from: -row.anchors.margins + row.spacing + panel.width / 3.32 * 2
                    to: 0
                    duration: 200
                }
                spacing: - panel.width / 1.88
                Repeater{
                    model: _insectTypeCount == 0? 1 : _insectTypeCount

                    delegate: Hexagon{
                        opacity: _insectTypeCount == 0? 0.1 : 1
                        enabled: isFace
                        id: insect
                        property bool dragged: false
                        sideLong: panel.width / 3.32
                        insectType: _insectTypeCount == 0? "" : _insectType
                        isBlack: _insectTypeCount == 0? false : panel.isBlack
                        property int homeX: x
                        property int homeY: y
                        property bool isOut: false
                        property bool isFace: _insectTypeCount != 0 && index == _insectTypeCount-1// && index !== 0
                        property bool isChecked: checkedInsectType == _insectType && isFace
                        property bool isHovered: false
                        property bool needToStandOut: isHovered || isChecked

                        onNeedToStandOutChanged: {
                            shaking.start(needToStandOut)
                            scaleAnimation.start(needToStandOut)
                        }
                        isChoiceMode: isChecked

                        MouseArea{
                            enabled: insect.enabled
                            id: insectMouseArea
                            anchors.fill: parent
                            hoverEnabled: true
                            onClicked: {
                                gameBoard.idToMove = -1
                                checkedInsectType = _insectType == checkedInsectType? "" : _insectType
                            }
                            onContainsMouseChanged: {
                                insect.isHovered = containsMouse
                            }
                        }

                        NumberAnimation {
                            id: scaleAnimation
                            property var scaleAim: 1
                            target: insect
                            property: "scale"
                            to: scaleAim
                            duration: 100
                            function start(toGrow){
                                scaleAim = toGrow? 1.2 : 1
                                restart()
                            }
                        }

                        NumberAnimation {
                            id: shaking
                            property bool isRight: true
                            property real durationScale: 2
                            property real durationStep: 150
                            target: insect
                            property: "rotation"
                            to: isRight? shakingStep : -shakingStep
                            duration: durationStep * durationScale
                            function start(toOn){
                                if(!toOn)
                                    insect.rotation = 0
                                durationStep = Math.random() * 70 + 80
                                running = toOn
                            }

                            onFinished: {
                                isRight = !isRight
                                shaking.restart()
                            }
                        }
                    }
                }
            }
        }
    }

    Rectangle{
        enabled: !myTurn
        visible: !myTurn
        anchors.fill: parent
        color: "black"
        radius: parent.radius
        opacity: 0.3
    }

}
