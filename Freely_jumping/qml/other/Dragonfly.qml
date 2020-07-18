import QtQuick 2.2
import Felgo 3.0
import"../"

EntityBase {
  id: fly

  entityType: "fly" // always name your entityTypes

  width: 32 // visual width of our platform
  height: 16 // visual height of our platform

  // leaf image for platform
  Image {
    id: flyImg
    source: "../../assets/img/jumpingshoes.png"
    anchors.fill: fly
  }

  // BoxCollider responsible for collision detection
  BoxCollider {
    id: flyCollider
    width: parent.width // actual width is the same as the parent entity
    height: parent.height - 20 // actual height is slightly smaller so the collision works smoother
    bodyType: Body.Dynamic // only Dynamic bodies can collide with each other
    collisionTestingOnlyMode: true // collisions are detected, but no physics are applied to the colliding bodies

    fixture.onBeginContact: {
      var otherEntity = other.getBody().target
      var otherEntityType = otherEntity.entityType

      if(otherEntityType === "Border") {
        fly.x = utils.generateRandomValueBetween(32, gameScene.width-64) // generate random x
        fly.y = 0 // the top of the screen
      }
    }
  }

  // platform movement
  MovementAnimation {
    id: movement
    target: fly // which object will be affected
    property: "y" // which property will be affected
    velocity: actor.impulse / 2 // impulse is y velocity of the frog
    running: actor.y < 210 // move only when the frog is jumping over the limit
  }

}
