import QtQuick 2.0
import Felgo 3.0
import "../"
 // needed for Body.Static

EntityBase {
  entityType: "coin"
  poolingEnabled: true     //so that if use removeEntity() function,the entity is still there,just invisible

  // put them before the windows
  z:1
  Image {
    id: sprite
    source: "../../assets/img/coin.png"
    width: 15
    height: 15
    anchors.centerIn: parent
  }

  //to do dection of collisions
  property alias collider: collider
  BoxCollider {
    id: collider
    width: parent.width
    height: parent.height
    collisionTestingOnlyMode: true

    bodyType: Body.Static
    anchors.fill: sprite
    // it should not affect the movement of the player
    sensor: true

  }

  //the two functions reset the coin's visible
  function resetcoin(){
      visible=true
  }

  function coindie(){
      visible=false
  }
}
