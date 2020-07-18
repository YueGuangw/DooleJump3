import Felgo 3.0
import QtQuick 2.0
import "scenes"


/*/////////////////////////////////////
  NOTE:
  Additional integration steps are needed to use Felgo Plugins, for example to add and link required libraries for Android and iOS.
  Please follow the integration steps described in the plugin documentation of your chosen plugins:
  - AdMob: https://felgo.com/doc/plugin-admob/
  - Soomla: https://felgo.com/doc/plugin-soomla/
  - Google Analytics: https://felgo.com/doc/plugin-googleanalytics/
  - OneSignal: https://felgo.com/doc/plugin-onesignal/

  To open the documentation of a plugin item in Qt Creator, place your cursor on the item in your QML code and press F1.
  This allows to view the properties, methods and signals of Felgo Plugins directly in Qt Creator.

/////////////////////////////////////*/

GameWindow {
  id: gameWindow

  // You get free licenseKeys from https://felgo.com/licenseKey
  // With a licenseKey you can:
  //  * Publish your games & apps for the app stores
  //  * Remove the Felgo Splash Screen or set a custom one (available with the Pro Licenses)
  //  * Add plugins to monetize, analyze & improve your apps (available with the Pro Licenses)
  //licenseKey: "<generate one from https://felgo.com/licenseKey>"

  // window size
  screenWidth: 640
  screenHeight: 960

  activeScene: gameScene

  BackgroundMusic{
      id:bagmusic
      source:"../assets/snd/dlam.mp3"
      autoLoad: true
      autoPlay: true
  }

//load a kind of font
  FontLoader {
    id: fontHUD
    source: "fonts/pf_tempesta_seven_compressed.ttf"
  }

  EntityManager {
    id: entityManager
    entityContainer: gameScene
  }

  // configure google analytics plugin
  GoogleAnalytics {
    id: ga

    // property tracking ID from Google Analytics dashboard
    propertyId: "UA-67377753-2"
  }

  // set up game network and achievements
  //save the player's highscore when the actor dies.
  //connects our game with the game network. Also it allows us to report scores and to organize achievements.
  //also responsible for achievements.
  FelgoGameNetwork {
    id: gameNetwork
    gameId: 173 // put your gameId here
    secret: "doodlefrogsecret12345" // put your game secret here
    gameNetworkView: actorNetworkView

    achievements: [

      Achievement {
        key: "5opens"     //record a new achievement!
        name: "Game Opener"
        target: 5         //the required number of increments to unlock an achievement
        points: 10        //points specifies the number of points the player gets when the achievement is unlocked.
        description: "Open this game 5 times"
      },

      Achievement {
        key: "die100"
        name: "Y U DO DIS?"
        iconSource: "../assets/achievementImage.png"
        target: 100
        description: "Die 100 times"
      }
    ]
  }

  // scene for the actual game
  Gamescene {
    id: gameScene
   onMenuScenePressed: {
     gameWindow.state = "menu"
    ga.logEvent("Click", "MenuScene")  //track events.
    }
  }

  // the menu scene of the game
  MenuScene {
    id: menuScene
    onGameScenePressed: {
      gameWindow.state = "game"
      ga.logEvent("Click", "GameScene")
    }

    // the game network view shows the leaderboard and achievements
    GameNetworkView {
      id: actorNetworkView
      visible: false
      anchors.fill: parent.gameWindowAnchorItem

      onShowCalled: {
        actorNetworkView.visible = true
      }

      onBackClicked: {
        actorNetworkView.visible = false
      }
    }
  }

  // default state is menu -> default(starting) scene is menuScene
  state: "menu"

  // state machine, takes care reversing the PropertyChanges when changing the state like changing the opacity back to 0
  //state machine then activates and shows the respective scene.
  states: [
    State {
      name: "menu"
      PropertyChanges {target: menuScene; opacity: 1}
      PropertyChanges {target: gameWindow; activeScene: menuScene}
    },
    State {
      name: "game"
      PropertyChanges {target: gameScene; opacity: 1}
      PropertyChanges {target: gameWindow; activeScene: gameScene}
    }
  ]
}
