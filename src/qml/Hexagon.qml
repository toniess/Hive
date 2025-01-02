import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Shapes 1.12
import QtQml 2.3
//import QtGraphicalEffects 1.0
Rectangle{
    id: hexagon
    property string imageSource : insectType ? "../images/" + insectType : ""
    property string insectType
    color: "transparent"
    rotation: 0

    function setRotation(oClocks){
        rotation = oClocks * 30
    }

    property bool isBlack: false
    property double centerX
    property double centerY
    property double sideLong: width/2

    property int normRotation

    property double startX: 0
    property double startY: sideLong

    property double halfSide: sideLong / 2
    property double deltaY: Math.sin(Math.PI / 3) * sideLong

    function getDeltaY(sideLong){
        return Math.sin(Math.PI / 3) * sideLong
    }
    property bool isChoiceMode: false
    property color choice: isBlack? "darkGreen" : "lightGreen"
    property color light: "#F3E5B9"
    property color dark: "#413C30"
    property color backColor: isChoiceMode? choice : !isBlack? light : dark

    function changeChoiceMode(isOn) {isChoiceMode = isOn}

    function weirdShake(){
        normRotation = hexagon.rotation
        weirdShakeAnimation.start()
    }

    NumberAnimation {
        id: weirdShakeAnimation
        property int step: 5
        property int loops: 0
        target: hexagon
        property: "rotation"
        to: normRotation + step
        duration: 50
        onFinished:
            if(loops < 4){
                step = -step
                loops++
                running = true
            }else{
                loops = 0
                hexagon.rotation = normRotation
            }
    }

    width: sideLong * 2;
    height: width

    x: centerX - sideLong
    y: centerY - sideLong
    Shape {
        anchors.fill: parent
        ShapePath {
            id: path
            strokeColor: "darkgrey"
            strokeWidth: sideLong / 14
            startX: hexagon.startX; startY: hexagon.startY
            fillColor: backColor

            PathLine{x: startX + halfSide;     y: startY - deltaY}
            PathLine{x: startX + halfSide * 3; y: startY - deltaY}
            PathLine{x: startX + halfSide * 4; y: startY}
            PathLine{x: startX + halfSide* 3;  y: startY + deltaY}
            PathLine{x: startX + halfSide * 3; y: startY + deltaY}
            PathLine{x: startX + halfSide;     y: startY + deltaY}
            PathLine{x: startX;                y: startY}
        }
        Image {
            anchors.centerIn: parent
            visible: hexagon.opacity == 1
            id: image
            source: hexagon.imageSource
            scale: sideLong / 80
        }
    }
}

