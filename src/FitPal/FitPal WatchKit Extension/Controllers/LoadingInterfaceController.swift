//
// Created by dykderrick on 2021/12/22.
//
// FitPal
//
// Copyright © 2021 Derrick Ding. All rights reserved.
//
	 

import Foundation
import WatchKit

class LoadingInterfaceController: WKInterfaceController {
    @IBOutlet weak var loadingLabel: WKInterfaceLabel!
    
    var workoutManager: WorkoutManager?
    var loadingTimer: Timer?
    var progressTracker = 1
    
    func startProgressIndicator() {
        // Reset progress and timer.
        progressTracker = 1
        loadingTimer?.invalidate()

        // Schedule timer.
        loadingTimer = Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(updateProgress), userInfo: nil, repeats: true)

        loadingLabel.setHidden(false)
    }

    @objc private func updateProgress() {
        if workoutManager?.hkWorkoutData != nil {
            stopProgressIndicator()
        }
        switch progressTracker {
        case 1:
            loadingLabel.setText("Loading..")
            progressTracker = 2
        case 2:
            loadingLabel.setText("Loading...")
            progressTracker = 3
        case 3:
            loadingLabel.setText("Loading.")
            progressTracker = 1
        default:
            break
        }
    }

    fileprivate func stopProgressIndicator() {
        loadingTimer?.invalidate()
        //loadingLabel.setHidden(true)
        presentController(withName: "WorkoutFinish", context: workoutManager)
    }
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        setTitle("")
        
        
        if let workoutManager = context as? WorkoutManager {
            self.workoutManager = workoutManager
        } else {
            print("Context is not a Workout type.")
        }
        
        startProgressIndicator()
    }
    
    override func willActivate() {
        super.willActivate()
    }
    
    override func didDeactivate() {
        super.didDeactivate()
    }
}
