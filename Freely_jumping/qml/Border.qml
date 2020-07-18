//add a new object, as a border, at the bottom of our screen.
//while actor falling down and touch this bottom,game restar!

import QtQuick 2.0
import Felgo 3.0

EntityBase {
  entityType: "Border"

  BoxCollider {
    width: gameScene.width * 5 // use large width to make sure the frog can't fly past it
    height: 50
    bodyType: Body.Static // this body shall not move

    collisionTestingOnlyMode: true //the positions are taken from the target and the colliders
                                   // are only used for collision detection but not for position updating.

    // a Rectangle to visualize the border
    Rectangle {
      anchors.fill: parent
      color: "red"
      visible: false // set to false to hide
    }
  }
}
