import QtQuick 2.2
import Felgo 3.0

EntityBase {
  id: spring

  entityType: "Spring" // always name your entityTypes

  width: 32 // visual width of our platform
  height: 16 // visual height of our platform

  // leaf image for platform
  Image {
    id: springImg
    source: "../../assets/img/jumpbed.png"
    anchors.fill: spring
  }

  // BoxCollider responsible for collision detection
  BoxCollider {
    id: springCollider
    width: parent.width // actual width is the same as the parent entity
    height: parent.height - 20 // actual height is slightly smaller so the collision works smoother
    bodyType: Body.Dynamic // only Dynamic bodies can collide with each other
    collisionTestingOnlyMode: true // collisions are detected, but no physics are applied to the colliding bodies

    fixture.onBeginContact: {
      var otherEntity = other.getBody().target
      var otherEntityType = otherEntity.entityType

      if(otherEntityType === "Border") {
        spring.x = utils.generateRandomValueBetween(32, gameScene.width-64) // generate random x
        spring.y = 0 // the top of the screen
      }
    }
  }

  // platform movement
  MovementAnimation {
    id: movement
    target: spring // which object will be affected
    property: "y" // which property will be affected
    velocity:  actor.impulse / 2 // impulse is y velocity of the frog
    running: actor.y < 210 // move only when the frog is jumping over the limit
  }

// wobble animation
  ScaleAnimator {
    id: swobbleAnimation
    target: spring
    running: false // default is false and it gets activated on every collision
    from: 0.9
    to: 1
    duration: 1000
    easing.type: Easing.OutElastic // Easing used get an elastic wobbling instead of a linear scale change
  }

  // function to start wobble animation
  function playWobbleAnimation() {
    swobbleAnimation.start()
  }
}
