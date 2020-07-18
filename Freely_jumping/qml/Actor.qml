//this file defines some property and action of actor

import QtQuick 2.0
import Felgo 3.0
import "other"
import "scenes"
EntityBase {
  id:actorEntity // the id we use as a reference inside this class

  entityType: "Actor" // always name your entityTypes

  state: actorCollider.linearVelocity.y < 0 ?  "jumping" : "falling"        // change state according to the actor's y velocity

  property int impulse: y-actorCollider.linearVelocity.y  // to move platforms down while actor jump high enough

  property alias controller: twoAxisController   // we make the actor's twoAxisController visible and accessible for the scene

  // actorCollider uses TwoAxisController to move the actor left or right.
  TwoAxisController {
    id: twoAxisController
  }

  // sprite for the frog, he can either be sitting or jumping
  SpriteSequence {
    id: actorAnimation

   // defaultSource: "/root/Freely_jumping/assets/dlam.png"
  defaultSource: "/root/Freely_jumping/assets/sp04.png"
  // scale:0.4
    scale: 0.2// our image is too big so we reduce the size of the original image to 35%
    anchors.centerIn: actorCollider

    // tilt the actor animation to make action more natural
    // when actor jumps it turns to the direction he moves
    rotation: actorEntity.state == "jumping" ?
                 (system.desktopPlatform ?
                    twoAxisController.xAxis * 15
                    : (accelerometer.reading !== null ? -accelerometer.reading.x * 10 : 0))
                : 0

    Sprite{
        name:"sitting"
        frameWidth: 256
        frameHeight: 256
        //startFrameColumn: 2

    }

    Sprite {
      name: "jumping"
      //frameCount: 4
      //frameRate: 8

      frameWidth:256
      frameHeight: 256
      frameX: 0
      frameY: 0
    }
    /*Sprite {
      name: "sitting"
      frameWidth: 128
      frameHeight:128
      startFrameColumn: 2
    }

    Sprite {
      name: "jumping"
      frameCount: 4
      frameRate: 8

      frameWidth:128
      frameHeight: 256
      frameX: 0
      frameY: 128
    }*/
  }

  // collider to check for collisions and apply gravity
  BoxCollider {
    id: actorCollider

    width: 25 // width of the frog collider
    height: 5 // height of the frog collider

    //When the state is gameOver, the frog should not be able to move
    bodyType: gameScene.state == "playing" ?  Body.Dynamic : Body.Static // do not apply gravity when the actor is dead or the game is not started

    // move the frog left and right
    linearVelocity.x: system.desktopPlatform ?
                        twoAxisController.xAxis * 200 :                                 //  for desktop,xAxis default setted between -1 and 1;
                        (accelerometer.reading !== null ? -accelerometer.reading.x * 100 : 0)   // for mobile

    //deal the collision while actor collider with bottom
   /* fixture.onContactChanged: {
      var otherEntity = other.getBody().target
      var otherEntityType = otherEntity.entityType

      if(otherEntityType === "Border") {
        dieSound.play()
        actor.die()
      }
      else if(otherEntityType === "Monster"){
          actor.die()
      }
      else if(otherEntityType === "Platform" && frogEntity.state ==="falling") {
        collisionSound.play()
        actorCollider.linearVelocity.y = -400

        otherEntity.playWobbleAnimation()
      }
      else if(otherEntityType === "Movingplatfrom" && actorEntity.state === "falling") {
        collisionSound.play()
        actorCollider.linearVelocity.y = -400

        otherEntity.mplayWobbleAnimation()
      }
    }*/
    fixture.onContactChanged: {
         var otherEntity = other.getBody().target
         var otherEntityType = otherEntity.entityType

         if(otherEntityType === "Border") {
           dieSound.play()
           actorEntity.die()
         }else if(otherEntityType === "fly"){
             actorCollider.linearVelocity.y=-2000
         }
         else if(otherEntityType==="master"){
             actorEntity.die()
             dieSound.play()
         }else if(otherEntityType === "Spring"){
             actorCollider.linearVelocity.y = -800
             otherEntity.mplayWobbleAnimation()
         }
         else if(otherEntityType==="Moveplatform" && actorEntity.state==="falling"){
             collisionSound.play()
             actorCollider.linearVelocity.y = -400
             //while actor jumping off,platform to wobble.
             otherEntity.mplayWobbleAnimation()
         }

         else if(otherEntityType === "Platform" && actorEntity.state == "falling") {
           actorCollider.linearVelocity.y = -400

           //while actor jumping off,platform to wobble.
           otherEntity.playWobbleAnimation()

         }
       }
  }

  //set soundeffect of game
  SoundEffect {
      id: collisionSound
      source: "../assets/snd/pling.wav"
  }
  SoundEffect {
      id: dieSound
      source: "../assets/snd/sfx_swooshing.wav"
  }

  // animations handling
  onStateChanged: {
    if(actorEntity.state == "jumping") {
      actorAnimation.jumpTo("jumping") // change the current animation to jumping
    }
    if(actorEntity.state == "falling") {
      actorAnimation.jumpTo("sitting") // change the current animation to sitting
    }
  }

  //to limit actor jump too high
  onYChanged: {
    if(y < 200) {
      y = 200 // limit the actor's y value

      //increase the score every time the actor gets higher than ever before
     // score += 1 // increase score
    }
  }

  // die and restart game
  function die() {
    // reset position
    actorEntity.x = gameScene.width / 2
    actorEntity.y = 220

    // reset velocity
    actorCollider.linearVelocity.y = 0

    // reset animation
    actorAnimation.jumpTo("sitting")

    //send the achieved score to the game network
    //f it is higher than his previous score, it will be saved as the player's new highscore.
    gameNetwork.reportScore(totalScore) // report the current score to the gameNetwork

   // score = 0
    bonusScore = 0//reset the score while actor die!
    //totalScore = 0

    //connect the actor's death with gameover!
    gameScene.state = "gameOver"

    //increment the second achievement every time our frog dies.
    gameNetwork.incrementAchievement("die100")
  }
}
