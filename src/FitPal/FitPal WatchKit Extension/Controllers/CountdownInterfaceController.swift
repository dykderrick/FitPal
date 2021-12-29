//
// Created by dykderrick on 2021/12/18.
//
// FitPal
//
// Copyright © 2021 Derrick Ding. All rights reserved.
//
	 

import Foundation
import WatchKit

class CountdownInterfaceController: WKInterfaceController {
    
    @IBOutlet weak var backgroundGroup: WKInterfaceGroup!
    @IBOutlet weak var countdownNumberLabel: WKInterfaceLabel!
    
    var counter = 5  // Total 5 seconds countdown
    var workoutManager: WorkoutManager?
    var timer: Timer?
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        setTitle("")
        
        
        if let workoutManager = context as? WorkoutManager {
            self.workoutManager = workoutManager
        } else {
            print("Context is not a Workout type.")
        }
        
        self.backgroundGroup.setBackgroundImage(UIImage(named: "count-down-5"))
        
        self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.updateCountdown), userInfo: nil, repeats: true)
        

    }
    
    
    override func willActivate() {
        super.willActivate()
    }
    
    override func didDeactivate() {
        super.didDeactivate()
    }
    
    // Invoke this function every second
    @objc func updateCountdown() {
        if counter > 0 {
            countdownNumberLabel.setText(counter.description)
            WKInterfaceDevice.current().play(WKHapticType.start)
            backgroundGroup.setBackgroundImage(UIImage(named: "count-down-\(counter)"))
            
            counter -= 1
        } else {
            timer?.invalidate()  // fire the current timer
            
            WKInterfaceDevice.current().play(WKHapticType.directionUp)
            
            // Use reloadRootPageControllers rather than presentControllers because we'll show the second page `WorkoutProgress` indexed at page 1 at appearing time first.
            WKInterfaceController.reloadRootPageControllers(withNames: ["WorkoutProgressControl", "WorkoutProgress", "NowPlaying"], contexts: [workoutManager as Any, workoutManager as Any, workoutManager as Any], orientation: WKPageOrientation.horizontal, pageIndex: 1)
        }
    }
}
