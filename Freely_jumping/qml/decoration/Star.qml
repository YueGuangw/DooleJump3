import QtQuick 2.0
import Felgo 3.0
import "../"
import"../scenes"

EntityBase {
  id:star
  entityType: "star"

  // put them before the windows
  z:1
  Image {
    source:"../../assets/img/snow.png"
    width: 18
    height: 18
    anchors.centerIn: parent
  }
  property alias collider: collider
  BoxCollider {
    id: collider
    width: parent.width
    height: parent.height
    collisionTestingOnlyMode: true

    bodyType: Body.Static

    fixture.onBeginContact: {
      var otherEntity = other.getBody().target
      var otherEntityType = otherEntity.entityType

      if(otherEntityType === "Border") {
        star.x = 0 // generate random x
        star.y = 0 // the top of the screen
      }
    }
  }
  MovementAnimation {
    target: star // which object will be affected
    property: "y" // which property will be affected
    velocity: 220
    minPropertyValue: 32
    maxPropertyValue: gameScene.height-64
    running: true                       // move only when the frog is jumping over the limit
  }
  onYChanged: {
      if(y == gameScene.height-64){
          y= 32
      }
  }

}

