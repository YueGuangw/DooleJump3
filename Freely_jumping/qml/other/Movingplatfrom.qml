import QtQuick 2.2
import Felgo 3.0
import"../"

EntityBase {
  id: moveplatform

  entityType: "Moveplatform" // always name your entityTypes
  width: 64 // visual width of our platform
  height: 32 // visual height of our platform

  // leaf image for platform
  Image {
    id: moveplatformImg
    source: "../../assets/img/jiantou.png"
    anchors.fill: moveplatform
  }

  // BoxCollider responsible for collision detection
  BoxCollider {
    id: moveplatformCollider
    width: parent.width // actual width is the same as the parent entity
    height: parent.height - 20 // actual height is slightly smaller so the collision works smoother
    bodyType: Body.Dynamic // only Dynamic bodies can collide with each other
    collisionTestingOnlyMode: true // collisions are detected, but no physics are applied to the colliding bodies

    fixture.onBeginContact: {
      var otherEntity = other.getBody().target
      var otherEntityType = otherEntity.entityType

      if(otherEntityType === "Border") {
        moveplatform.x = 0 // generate random x
        moveplatform.y = 0 // the top of the screen
      }
    }
  }

  // platform movement
  MovementAnimation {
    target: moveplatform // which object will be affected
    property: "y" // which property will be affected
    velocity:  actor.impulse / 2 // impulse is y velocity of the frog
    running: actor.y < 210 // move only when the frog is jumping over the limit
  }
  MovementAnimation {
    target: moveplatform // which object will be affected
    property: "x" // which property will be affected
    velocity: 80
    minPropertyValue: 32
    maxPropertyValue: gameScene.width-64
    running: true// move only when the frog is jumping over the limit
  }
  onXChanged: {
      if(x == gameScene.width-64){
          x = 32
      }
  }
// wobble animation
  ScaleAnimator {
    id: movewobbleAnimation
    target: moveplatform
    running: false // default is false and it gets activated on every collision
    from: 0.9
    to: 1
    duration: 1000
    easing.type: Easing.OutElastic // Easing used get an elastic wobbling instead of a linear scale change
  }

  // function to start wobble animation
  function mplayWobbleAnimation() {
    movewobbleAnimation.start()
  }
}
