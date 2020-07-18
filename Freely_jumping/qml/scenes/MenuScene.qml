//this file decorate the menu

import QtQuick 2.0
import Felgo   3.0
import "../"

SceneBase{
    id :menuScene

    signal gameScenePressed

    Image {
        anchors.fill: menuScene.gameWindowAnchorItem
        source: "../../assets/img/pinkback.png"
    }

    Row{
        //anchors.centerIn: parent

        Rectangle{
            x:menuScene.width/2-img.width/2
            y:0
            id:text
            Image {
                width: 200
                height: 60
                id: img
                source: "../../assets/img/doodle-jump.png"
                anchors.centerIn: menuScene
            }
        }
    }

    //列元素能帮助我们确定我们的菜单的布局。
    Column {

        anchors.centerIn: parent
        spacing: 20        //the distance of each Function button

        // play button to start game
        Rectangle {
          id:play
          width: 150
          height: 50
          color: "pink"
          Image {
            width: parent.width
            height: parent.height
            id: gameSceneButton
            source: "/root/Freely_jumping/assets/play.png"
            anchors.centerIn: parent
          }

          MouseArea {
            id: gameSceneMouseArea
            anchors.fill: parent
            onClicked: gameScenePressed()
          }
        }

        //the button of score
        Rectangle {
          id:score
          width: play.width
          height: play.height
          color: "pink"
          Image {
            width: parent.width
            height: parent.height
            id: scoreSceneButton
            source: "../../assets/achievement.png"
            anchors.centerIn: parent
          }
          MouseArea {
            id: scoreSceneMouseArea
            anchors.fill: parent
            onClicked: actorNetworkView.visible = true
          }
        }

        //the button of quit game
        Rectangle{
            id:quit
            width:play.width
            height:play.height
            color: "lightblue"
            Text {
                //font.family: fl.name
                text: qsTr(" Quit   Game")
                font.family: fontHUD.name
                font.pixelSize: 30
                color: "white"
            }
            MouseArea{
                id:quitMouseArea
                anchors.fill: parent
                onClicked: Qt.quit()
            }
        }

        //the button of SoundEffect
        Rectangle{
            id:shift
            width:play.width
            height: play.height
            color: "lightblue"
            Column {
            spacing: 15
            anchors.horizontalCenter: parent.horizontalCenter
            y: 5

           MenuButton {
            text: settings.soundEnabled ? qsTr("Sound On") : qsTr("Sound Off")
            width: 170 * 0.8
            height: 60 * 0.8

            onClicked: {
              settings.soundEnabled = !settings.soundEnabled
              // also set the musicEnabled to the same value as soundEnabled
              settings.musicEnabled = settings.soundEnabled
            }

          }
        }
        }

        //there are some child GameWindow to show some information

        //row
        Row {
          // button to open chartboost interstitial
          Image {
            id: chartboostButton
            source: "../../assets/img/chartboostButton.png"

            MouseArea {
              anchors.fill: parent
              onClicked: {
                if(system.desktopPlatform)
                  nativeUtils.displayMessageBox("Ads are only available on iOS and Android.To test the Chartboost plugin, open the Doodle Jump game project and deploy the game to your iOS or Android device.")
                else
                  chartboost.showInterstitial()
              }
            }
          }
          // button to open admob interstitial
          Image {
            id: admobButton
            source: "../../assets/img/admobButton.png"

            MouseArea {
              anchors.fill: parent
              onClicked: {
                if(system.desktopPlatform)
                  nativeUtils.displayMessageBox("Ads are only available on iOS and Android.
                  To test the AdMob plugin, open the Doodle Jump game project and deploy
                  the game to your iOS or Android device.")
                else
                  interstitial.loadInterstitial()
              }
            }
          }
        }
      }

      // configure the admob banner
      AdMobBanner {
        //adUnitId: "ca-app-pub-5893836292676877/1041507143"
        adUnitId: "ca-app-pub-5893836292676877/7730182343"

        banner: system.desktopPlatform ? 0 : AdMobBanner.Smart // theAdMobBanner enum is only available on iOS & Android; to prevent a warning, only set it on these platforms to a Smart Banner

        anchors.horizontalCenter: parent.Center
        visible: !actorNetworkView.visible

        testDeviceIds: ["7AA2ECE6469E41E0C8E5ABAFCC7A0BB9", "3385843ff1e43633521e3750a6d57fed", "28CA0A7F16015163A1C70EA42709318A"]
      }

      // configure the admob interstitial
      AdMobInterstitial {
        id: interstitial

        //adUnitId: "ca-app-pub-5893836292676877/2518240347"
        adUnitId: "ca-app-pub-5893836292676877/9206915541"

        onInterstitialReceived: {
          showInterstitialIfLoaded()
        }

        onInterstitialFailedToReceive: {
          console.debug("Interstitial not loaded")
        }

        testDeviceIds: ["7AA2ECE6469E41E0C8E5ABAFCC7A0BB9", "3385843ff1e43633521e3750a6d57fed", "28CA0A7F16015163A1C70EA42709318A"]
      }

      // configure the chartboost interstitial
      Chartboost {
        id: chartboost

        appId: Qt.platform.os === System.IOS ? "55f2a8145b145373586f4b16" : "55f2a8155b145373586f4b18"
        appSignature: Qt.platform.os === System.IOS ? "8b2d667bac3e06e60c08c06e4e63898fcad52cfd" : "f8b21bf14f5b85cc62612765300ce4c205664b0a"

        // Do not use reward videos in this example
        shouldDisplayRewardedVideo: false

        // allows to show interstitial also at first app startup.
        // see http://www.felgo.com/doc/felgo-chartboost/#shouldRequestInterstitialsInFirstSession-prop
        shouldRequestInterstitialsInFirstSession: true

        onInterstitialCached: {
          console.debug("InterstitialCached at location:", location)
        }

        onInterstitialFailedToLoad: {
          console.debug("InterstitialFailedToLoad at location:", location, "error:", error)
        }
      }
}
