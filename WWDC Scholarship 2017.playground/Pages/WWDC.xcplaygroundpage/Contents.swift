import UIKit
import PlaygroundSupport
let vc = ViewController()

/*
 * Virtual Clock playground
 *
 * Written by Jack Bruienne
 * (JackMacWindows online)
 * for WWDC 2017 Scholarships
 *
 * Written March 13-28, 2017
 *
 * This program is USER-INTERACTIVE
 * giving tutorials on how to
 * change the val's to how you like
 * it. The view itself is
 * user-interactable.
 *
 */

// Change the background color
vc.color = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)

// Change the time color
vc.timeColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)

// Change the time style
// 0 = rectangles, 1 = ovals,
// 2 = 7-segment, 3 = 8-bit-like
vc.timeType = 2

// Use 12-hour / 24-hour time?
vc.use24h = false

// Beginning time to start at
// Written in 24-hour format
//If you don't want to show seconds
// on the clock, don't write any.
vc.startTime = "6:25:15"








PlaygroundPage.current.liveView = vc.view
