//
// Created by dykderrick on 2021/12/18.
//
// FitPal
//
// Copyright © 2021 Derrick Ding. All rights reserved.
//
	 

import Foundation
import WatchKit

class BreathoutInterfaceController: WKInterfaceController {
    @IBOutlet weak var breathoutCountGroup: WKInterfaceGroup!
    @IBOutlet weak var breathoutLabel: WKInterfaceLabel!
    @IBOutlet weak var bpmLabel: WKInterfaceLabel!
    @IBOutlet weak var bpmImage: WKInterfaceImage!
    
    var workoutManager: WorkoutManager?
    var counter = 15 * 50  // Breathout for 15 seconds at 50 fps
    var timer: Timer?
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        setTitle("")
        
        // receive workoutManager as context
        if let workoutManager = context as? WorkoutManager {
            self.workoutManager = workoutManager
        } else {
            print("Context is not a Workout type.")
        }
        
        breathoutCountGroup.setBackgroundImage(UIImage(named: "breathout0"))
        bpmImage.setImage(UIImage(named: "Heart"))
        
        
        timer = Timer.scheduledTimer(timeInterval: 1.0 / 50, target: self, selector: #selector(updateBreathout), userInfo: nil, repeats: true)
        
    }
    
    override func willActivate() {
        super.willActivate()
    }
    
    override func didDeactivate() {
        super.didDeactivate()
    }
    
    @objc func updateBreathout() {
        if counter > 0 {
            if counter % 50 == 0 {  // actions for every second
                breathoutLabel.setText((counter / 50).description)
                WKInterfaceDevice.current().play(WKHapticType.start)
                bpmLabel.setText(workoutManager?.realTimeHeartRate.description)
            }
            breathoutCountGroup.setBackgroundImage(UIImage(named: "breathout\(counter)"))
            counter -= 1
        } else {
            timer?.invalidate()  // fire the current timer
            
            workoutManager?.workout?.currentGroup += 1  // Safe += 1. We compare the value of currentGroup vs totalGroup in WorkoutProgressControllerInterface.swift
            //presentController(withNames: ["WorkoutProgressControl", "WorkoutProgress", "NowPlaying"], contexts: [workoutManager, workoutManager, workoutManager])
            // Use reloadRootPageControllers because we'll show the second page `WorkoutProgress` indexed at page 1 at appearing time first.
            workoutManager?.startRecordingAccelarations()  // After breath out, resume recording
            WKInterfaceController.reloadRootPageControllers(withNames: ["WorkoutProgressControl", "WorkoutProgress", "NowPlaying"], contexts: [workoutManager as Any, workoutManager as Any, workoutManager as Any], orientation: WKPageOrientation.horizontal, pageIndex: 1)
        }
    }
    
}
