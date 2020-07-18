//this file defines the basic property of the scene in the game
//在此类中，我们为所有其他场景设置默认值width和height值。我们还定义了一些基本的场景过渡属性。稍后我们将需要它们在场景之间导航。

import Felgo 3.0
import QtQuick 2.0

Scene {
  id: sceneBase

  width: 320
  height: 480

  // by default, set the opacity to 0. We handle this property from Main.qml via PropertyChanges.
  opacity: 0

  // the scene is only visible if the opacity is > 0. This improves performance.
  visible: opacity > 0

  // only enable scene if it is visible.
  enabled: visible
}
