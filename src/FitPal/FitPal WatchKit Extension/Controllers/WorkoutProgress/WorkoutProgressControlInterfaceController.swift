//
// Created by dykderrick on 2021/12/20.
//
// FitPal
//
// Copyright © 2021 Derrick Ding. All rights reserved.
//
	 

import Foundation
import WatchKit

/// This class is the interface controller for Page `WorkoutProgress`.
class WorkoutProgressControlInterfaceController: WKInterfaceController {
    @IBOutlet weak var stopButton: WKInterfaceButton!
    @IBOutlet weak var pauseResumeButton: WKInterfaceButton!
    @IBOutlet weak var skipButton: WKInterfaceButton!
    
    
    var workoutManager: WorkoutManager?
    
    @IBAction func stopButtonClicked() {
        workoutManager?.stopWorkout()
        presentController(withName: "Loading", context: workoutManager)
    }
    
    @IBAction func pauseResumeButtonClicked() {
        WKInterfaceDevice.current().play(WKHapticType.click)
        if workoutManager?.isWorkingout == true {  // To Pause
            workoutManager?.pauseWorkout()
            pauseResumeButton.setBackgroundImage(UIImage(named: "resume-button-new"))
        } else {  // To Resume
            WKInterfaceDevice.current().play(WKHapticType.click)
            workoutManager?.resumeWorkout()
            pauseResumeButton.setBackgroundImage(UIImage(named: "pause-button-new"))
        }
    }
    
    @IBAction func skipButtonClicked() {
        skipToNextGroup(controller: self, workoutManager: workoutManager!)
    }
    
    fileprivate func setImages() {
        stopButton.setBackgroundImage(UIImage(named: "stop-button-new"))
        pauseResumeButton.setBackgroundImage(UIImage(named: "pause-button-new"))
        skipButton.setBackgroundImage(UIImage(named: "skip-button-new"))
    }
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        setTitle("")
        setImages()
        
        if let workoutManager = context as? WorkoutManager {
            self.workoutManager = workoutManager
        } else {
            print("Context is not a Workout type.")
        }
        
        if ((workoutManager?.isWorkingout) != nil) {
            pauseResumeButton.setBackgroundImage(UIImage(named: "pause-button-new"))
        } else {
            pauseResumeButton.setBackgroundImage(UIImage(named: "resume-button-new"))
        }
    }
    
    override func willActivate() {
        super.willActivate()
    }
    
    override func didDeactivate() {
        super.didDeactivate()
    }
}
