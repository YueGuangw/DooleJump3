//this file define some property and action of platform
//include some collision dection
//there also are some decoration of scene

import QtQuick 2.2
import Felgo 3.0
import "other"
import"scenes"

EntityBase {
  id: platform

  entityType: "Platform"     // always name your entityTypes

  width: 64 // visual width of our platform
  height: 32 // visual height of our platform

  property bool addextrlscore: true

  Coin{
      id:coin
      x:platform.width/2
      y:-1
  }

  // leaf image for platform
  Image {
    id: platformImg
    source: "/root/Freely_jumping/assets/img/whitemood.png"
    anchors.fill: platform
  }

  // BoxCollider responsible for collision detection
  BoxCollider {
    id: platformCollider
    width: parent.width // actual width is the same as the parent entity
    height: parent.height - 20 // actual height is slightly smaller so the collision works smoother
    bodyType: Body.Dynamic // only Dynamic bodies can collide with each other
    collisionTestingOnlyMode: true // collisions are detected, but no physics are applied to the colliding bodies

    //similar to the actor's collision handling.
    //We check the entityType of the other object, and if it's a border, we re-set the platform's position.
    fixture.onBeginContact: {
      var otherEntity = other.getBody().target
      var otherEntityType = otherEntity.entityType

      if(otherEntityType!=="Border"){

          //get the diatance of actor and platform,and set the coin's visible by it
          //what's more,the score of coin is there
          //if coin is invisible,the score can't added
          //coin is invisible except it isn't been eatten.
          //visible of coin will be reset  with platform while it'y property more than scene's height value
          if(actor.x-platform.x>-(actor.width+platform.width/2) && actor.x-platform.x<platform.width+actor.width &&platform.addextrlscore===true){
              coin.coindie()
              bonusScore++
              platform.addextrlscore=false

          }
      }

      if(otherEntityType === "Border") {
        platform.x = utils.generateRandomValueBetween(32, gameScene.width-64) // generate random x
        platform.y = 0 // the top of the screen

         //reset the coin's visible while arriving border
         coin.resetcoin()
         platform.addextrlscore=true    //make score be added posiblely
      }
    }
   
  }

  // platform movement down
  MovementAnimation {
    id: movement
    target: platform   // which object will be affected
    property: "y"      // which property will be affected
    velocity: actor.impulse/2 // impulse is y velocity of the actor
    running: actor.y < 210         // move only when the actor is jumping over the limit
  }

  // wobble animation
  //The ScaleAnimator scales the platform's image between the two values specified in from and to.
  //You can start the animation via the function playWobbleAnimation().
  ScaleAnimator {
    id: wobbleAnimation
    target: platform
    running: false // default is false and it gets activated on every collision
    from: 0.8
    to: 1
    duration: 1000
    easing.type: Easing.OutElastic // Easing used get an elastic wobbling instead of a linear scale change
  }

  // function to start wobble animation
  function playWobbleAnimation() {
    wobbleAnimation.start()
  }

}

