//this file is used to decorate the gameScene

import QtQuick 2.0
import Felgo 3.0
import QtSensors 5.5
import "../"
import "../other"
import"../decoration"

SceneBase {
  id: gameScene

  // actual scene size
  width: 320
  height: 480

  //prepare for returning menuscene
  signal menuScenePressed

  //there are three state:start,playgame,gameover
  //state change:start->playgame,gameover->start
  state: "start"     //set initinal state

  //some property defination used frequently in program
  property int bonusScoreForcoin: 500  //while eat coin,the score we get
  property int bonusScore: 0
  property int totalScore: score + (bonusScore * bonusScoreForcoin)
  property int score: 0
  //navigate from the GameScene to the MenuScene.
  //signal menuScenePressed

  // increment achievement whenever game scene is created (once per app start)
  Component.onCompleted: gameNetwork.incrementAchievement("5opens")  //triggered when our gameScene is successfully created

  // background image
  Image {
    anchors.fill: parent.gameWindowAnchorItem
    source: "../../assets/img/pinkback.png"
  }

  // key input will be handled by the controller in our actor entity
  Keys.forwardTo: actor.controller

  // accelerometer can be used to react to tilting the phone
  Accelerometer {
    id: accelerometer
    active: true
  }

  // add physics world to use gravity and collision detection
  PhysicsWorld {
    debugDrawVisible: false // turn it on for debugging
    updatesPerSecondForPhysics: 60
    gravity.y: 20 // how much gravity do you want?
  }

  // the repeater adds ten platforms to the scene
  Repeater {
    model: 9 // every platorm gets recycled so we define
    Platform {
      id:pla
      x: utils.generateRandomValueBetween(0, gameScene.width-64) // random value
      y: gameScene.height / 9 * index // distribute the platforms across the screen

    }
  }

  //the movingplatform,
  Repeater {
    model: 1 // every platorm gets recycled so we define only ten of them
    Movingplatfrom {
      x: utils.generateRandomValueBetween(0, gameScene.width) // random value
      y: gameScene.height / 1 * index // distribute the platforms across the screen
    }
  }

  //the monster in scene,once touched,gameover
  Repeater {
    model: 1 // every platorm gets recycled so we define
    Monster {
      x: utils.generateRandomValueBetween(20, gameScene.width-64) // random value
      y: gameScene.height /  1* index // distribute the platforms across the screen1

    }
  }

  //some decorations in scene
  Repeater{
      model:3
      Star{
          id:st
          x:utils.generateRandomValueBetween(st.width,gameScene.width-st.width)
          y:utils.generateRandomValueBetween(st.height,gameScene.height/2)
      }
  }
  Repeater{
      model: 3
      Littlebell{
          id:lb
          x:utils.generateRandomValueBetween(lb.width,gameScene.width-lb.width)
          y:utils.generateRandomValueBetween(lb.height,gameScene.height/2)
      }
  }

  Repeater{
      model:2
      Plane{
          id:pl
          x:utils.generateRandomValueBetween(pl.width,gameScene.width-pl.width)
          y:utils.generateRandomValueBetween(pl.height,gameScene.height/2)
      }
  }

  Repeater {
    model: 1 // every platorm gets recycled so we define only ten of them
    Spring{
        id:sp
        x: utils.generateRandomValueBetween(sp.width,gameScene.width-sp.width) // random value
        y: gameScene.height / 1 * index // distribute the platforms across the screen
    }
  }

  Repeater {
    model: 1 // every platorm gets recycled so we define only ten of them
    Dragonfly{
      x: utils.generateRandomValueBetween(0, gameScene.width) // random value
      y: gameScene.height / 1 * index // distribute the platforms across the screen
    }
  }

  // this platform is placed directly under the frog for the start
  Platform {
    id:plat
    x: gameScene/4
    y: 300
  }

  Movingplatfrom{
    x:130
    y:200
  }
  Star{
      x:60
      y:50
  }

  // the frog entity (player)
  Actor {
    id: actor
    x: gameScene.width / 2 // place the frog in the horizontal center
    y: 220
  }

  // border at the bottom of the screen, used to check game-over
  Border {
    id: border
    x: -gameScene.width*2
    y: gameScene.height-10 // subtract a small value to make the border just visible in our scene
  }

  // show current player score
  Image {
    id: scoreCounter
    source: "../../assets/img/scoreCounter.png"
    height: 80
    x: -15
    y: -15
    // text component to show the score final gain!
    Text {
      id: scoreText
      anchors.centerIn: parent
      color: "white"
      font.pixelSize: 32
      text: totalScore           //there is shown of final score
    }
  }

  // start the game when user touches the screen
  //and exchange the state
  MouseArea {
    id: mouseArea
    anchors.fill: gameScene.gameWindowAnchorItem
    onClicked: {
      if(gameScene.state === "start") { // if the game is ready and the screen is clicked we start the game
        gameScene.state = "playing"
      }
      if(gameScene.state === "gameOver") // if the frog is dead and the screen is clicked we restart the game
      {
              gameScene.state = "start"

      }
    }
  }

  //decorate the gameover scene
  //Then add overlay Image
  // show info image depending on the state (gameover, start)
  Image {
    id: infoText
    anchors.centerIn: parent
    width:parent.width/2
    height:parent.height/6
    source: gameScene.state == "gameOver" ? "../../assets/race-over.png" : "../../assets/play.png"


    visible: gameScene.state !== "playing"
  }

  //this makes it possible to return menu if gameover
 /* Rectangle{
      id:back
      width:infoText.width
      height:infoText.height/4
      color: "skyblue"
      Text {id: text;font.family: fontHUD.name;font.pixelSize: 30;text: qsTr("Back To Menu");color: "white"}
      x:gameScene.width-back.width-10
      y:gameScene.height-(back.height+60)
      visible: gameScene.state=="gameOver"//||gameScene.state=="playing"
      MouseArea{
          id:mousearea
          anchors.fill: parent
          onClicked: {
              menuScenePressed()       //with signal menuScenePressed,this function is default by system
          }
      }
  }*/

  // options button to jump back to menu
  Image {
    id: menuButton
    source: "../../assets/options.png"
    width:80
    height:80
    x: gameScene.width - width
    y: -height/4
    scale: 0.5

    MouseArea {
      id: menuButtonMouseArea
      anchors.fill: parent
      onClicked: {
        menuScenePressed()

        // reset the gameScene
        actor.die()
        gameScene.state = "start"
      }
    }
    

  /*//to show leaderboard while clicked after gameover
  SimpleButton {
    text: "* Leaderboard *"
    color: "orange"
    visible: gameScene.state == "gameOver" // the button appears when the frog dies
    onClicked: {
      gameNetwork.showLeaderboard() // open the leaderboard view of the GameNetworkView
    }
  }*/
}
}
