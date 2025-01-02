import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Shapes 1.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import QtQml 2.3

Rectangle{
    id: gameBoard
    color: mainWindow.backgroungColor
    property int sideLong
    property var currentInsectType: ["", false]
    property int idToMove: -1
    property int currentTurn: 1

    readonly property int insectName: 0
    readonly property int insectIsBlack: 1

    signal changeShakingMode(var on)
    signal cutBack(var insectType, var isBlack)
    signal offSellChoiceMode()
    signal weirdShaking(var id)
    signal rotate(var id, var oClocks)
    signal setMovable(var id, bool movable)

    onIdToMoveChanged: {choiceMode(idToMove); offSellChoiceMode()}

    signal choiceMode(var id)

    function checkMovable(id){
        for(var i = 0; i < mesh.count; i++)
            if(mesh.get(i)._centerX === mesh.get(id)._centerX && mesh.get(i)._centerY === mesh.get(id)._centerY
                    && mesh.get(i)._store > mesh.get(id)._store)
                return false
        return true
    }

    function delInsectHex(id){
        mesh.remove(id)
        for(var i = id; i < mesh.count; i++)
            mesh.setProperty(i, "_id", i);
    }

    function nextTurn(){
        currentTurn ++;
        idToMove = -1
    }

    function hexClicked(id){
        var insect = mesh.get(id);
        var undefined = ""
        if(idToMove === id || !checkMovable(id) || (insect._insectType !== undefined && currentInsectType[insectName] !== "")){
            idToMove = -1
            weirdShaking(id)
        }else if(insect._insectType === undefined && currentInsectType[insectName] !== "")
            tryToPutInsectIntoBoardHexagon(id)
        else if(insect._insectType === undefined && idToMove != -1)
            tryToMoveInsect(idToMove, id)
        else if(insect._insectType !== undefined && idToMove != -1)
            tryToPullUp(idToMove, id)
        else if(insect._insectType !== undefined && currentInsectType[insectName] === "" && idToMove == -1){
            idToMove = id
        }
        offSellChoiceMode()
    }

    function getHiStore(id){
        var store = -1
        for(var i = 0; i < mesh.count; i++)
            if(mesh.get(i)._centerX === mesh.get(id)._centerX && mesh.get(i)._centerY === mesh.get(id)._centerY
                    && mesh.get(i)._store > mesh.get(id)._store)
                id = i
        return id
    }

    function  tryToPullUp(firstId, secId){
        addEmptyHexagon(mesh.get(secId)._centerX, mesh.get(secId)._centerY, mesh.get(secId)._sideLong * 0.9)
        var newStore = mesh.get(secId)._store + 1
        secId = mesh.count - 1
        mesh.setProperty(secId, "_store", newStore)
        tryToMoveInsect(firstId, secId)
    }

    function tryToMoveInsect(firstId, secId){
//        if(true/*hasInsectNeighbor(secId) || mesh.get(secId)._store > 0*/){
            mesh.setProperty(secId, "_insectType", mesh.get(firstId)._insectType)
            mesh.setProperty(secId, "_isBlack", mesh.get(firstId)._isBlack)
            mesh.setProperty(secId, "_opacity", mesh.get(firstId)._opacity)

            nextTurn()
            if(mesh.get(firstId)._store > 0){
               delInsectHex(firstId)
            }else{
                mesh.setProperty(firstId, "_insectType", "")
                mesh.setProperty(firstId, "_isBlack", false)
                mesh.setProperty(firstId, "_opacity", 0.4)
            }
            openHexRound(secId)
            rotate(secId, getAppropriateRotation(secId, mesh.get(secId)._isBlack))
//        }else{
//            weirdShaking(id)
//        }
    }

    function hasInsectNeighbor(id){
        var neighbor = getNeighbours(id)
        for (var index in neighbor)
            if(mesh.get(getId(neighbor[index].x, neighbor[index].y))._insectType !== undefined)
                return true
        return false
    }

    function getId(x, y){
        for(var i in mesh)
            if(i._centerX === x && i._centerY === y)
                return i._id
        return -1
    }

    function getNeighbours(id){
        var startX = mesh.get(id)._centerX
        var startY = mesh.get(id)._centerY
        var location = [{'x': startX,                  'y': startY - 2 * getDeltaY(sideLong)},
                        {'x': startX + 1.5 * sideLong, 'y': startY - getDeltaY(sideLong)    },
                        {'x': startX + 1.5 * sideLong, 'y': startY + getDeltaY(sideLong)    },
                        {'x': startX,                  'y': startY + 2 * getDeltaY(sideLong)},
                        {'x': startX - 1.5 * sideLong, 'y': startY + getDeltaY(sideLong)    },
                        {'x': startX - 1.5 * sideLong, 'y': startY - getDeltaY(sideLong)    }]
        return location
    }

    function canPut(id, isBlack){
        var undefined = ""
        //проверка на пустоту ячейки
        if(mesh.get(id)._insectType !== undefined)
                return false
        //проверка на касание только своего цвета (после 2-го хода)
        if(currentTurn > 2){
            var neighbors = getNeighbours(id)
            for(var index in neighbors)
                if(!appropriateColor(neighbors[index].x, neighbors[index].y, isBlack)) return false
        }
        return true
    }

    function appropriateColor(centerX, centerY, isBlack){
        var id = -1
        var store = -1
        for(var i = 0; i < mesh.count; i++)
            if(mesh.get(i)._centerX === centerX && mesh.get(i)._centerY === centerY && mesh.get(i)._store > store)
                id = i

        return id > -1? mesh.get(id)._opacity < 1 || mesh.get(id)._isBlack === isBlack : true
    }

    function getAppropriateRotation(id, isBlack){
        var location = getNeighbours(id)
        for(var index in location)
            if(!isEmptyHex(location[index].x, location[index].y)) return index * 2
        return 0
    }

    function isEmptyHex(x, y){
        for(var i = 0; i < mesh.count; i++)
            if(mesh.get(i)._centerX === x && mesh.get(i)._centerY === y)
                return mesh.get(i)._opacity < 1
    }

    function tryToPutInsectIntoBoardHexagon(id){
        if(currentInsectType[insectName] !== "")
            if(canPut(id, currentInsectType[insectIsBlack])){
                setInsectIntoHexagon(id, currentInsectType[insectName], currentInsectType[insectIsBlack])
                if(currentTurn > 1) rotate(id, getAppropriateRotation(id))
                cutBack(currentInsectType[0], currentInsectType[1])
                nextTurn()
            }else weirdShaking(id)
        offSellChoiceMode()
    }

    function setInsectIntoHexagon(setId, _insectType, _isBlack){
        mesh.setProperty(setId, "_insectType", _insectType)
        mesh.setProperty(setId, "_isBlack", _isBlack)
        mesh.setProperty(setId, "_opacity", 1)
        openHexRound(setId)
    }

    function addEmptyHexagon(centerX, centerY, sideLong){
        mesh.append({"_id": mesh.count,
                    "_centerX": centerX,
                    "_centerY": centerY,
                    "_sideLong": sideLong,
                    "_opacity": 0.4,
                    "_insectType": "",
                    "_isBlack": false,
                    "_store": 0})
    }

    function openHexRound(id){
        var sideLong = gameBoard.sideLong
        var location = getNeighbours(id)
        for(var index in location)
            if(!isHexOpened(location[index].x, location[index].y))
                addEmptyHexagon(location[index].x, location[index].y, sideLong)
    }

    function isHexOpened(centerX, centerY){
        for(var i = 0; i < mesh.count; i++)
            if(mesh.get(i)._centerX === centerX && mesh.get(i)._centerY === centerY)
                return true
        return false
    }

    function getDeltaY(sideLong){
        return Math.sin(Math.PI / 3) * sideLong
    }

    ListModel{
        id: mesh
    }

    Flickable{
        id: scroll
        anchors.fill: parent
        ScrollBar.vertical: ScrollBar{policy: ScrollBar.AlwaysOff;}
        ScrollBar.horizontal: ScrollBar{policy: ScrollBar.AlwaysOff;}

        interactive: true
        contentHeight: mainWindow.height * 2
        contentWidth: mainWindow.width * 2

        Component.onCompleted: {ScrollBar.vertical.position = 0.25; ScrollBar.horizontal.position = 0.25}

        Item {
            id: item
            anchors.fill: parent
            PinchHandler{}
            Repeater{
                model: mesh
                delegate: Hexagon{
                    id: insect
                    sideLong:   _sideLong
                    centerX:    _centerX
                    centerY:    _centerY
                    opacity:    _opacity
                    insectType: _insectType
                    isBlack:    _isBlack

                    MouseArea{
                        anchors.fill: parent
                        anchors.margins: sideLong * 0.25
                        onClicked: hexClicked(_id)
                    }

                    Connections{
                        target: gameBoard
                        function onWeirdShaking(id){ if(id === _id) insect.weirdShake()}
                        function onRotate(id, oClocks){ if(id === _id) insect.setRotation(oClocks)}
                        function onChoiceMode(id){insect.changeChoiceMode(id === _id)}
                    }
                }
            }
        }
    }
}
