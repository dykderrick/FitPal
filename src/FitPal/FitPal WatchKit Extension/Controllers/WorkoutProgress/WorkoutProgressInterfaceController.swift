//
// Created by dykderrick on 2021/12/18.
//
// FitPal
//
// Copyright © 2021 Derrick Ding. All rights reserved.
//
	 

import Foundation
import CoreMotion
import WatchKit
import HealthKit
import WatchConnectivity

class WorkoutProgressInterfaceController: WKInterfaceController {
    
    @IBOutlet weak var currentWorkoutCountGroup: WKInterfaceGroup!
    @IBOutlet weak var currentWorkoutCountLabel: WKInterfaceLabel!
    @IBOutlet weak var currentScoreGroup: WKInterfaceGroup!
    @IBOutlet weak var currentScoreLabel: WKInterfaceLabel!
    @IBOutlet weak var facilityImage: WKInterfaceImage!
    @IBOutlet weak var currentGroupLabel: WKInterfaceLabel!
    @IBOutlet weak var durationLabel: WKInterfaceLabel!
    
    
    var workout: Workout?
    var workoutManager: WorkoutManager?
    var updateTimer: Timer?
    var lastCount = 0
    
    
    
    fileprivate func setImages() {
        currentWorkoutCountGroup.setBackgroundImage(UIImage(named: "workout-count-0"))
        currentScoreGroup.setBackgroundImage(UIImage(named: "GreenScore"))
        facilityImage.setImage(UIImage(named: "BenchPressMoji"))
    }
    

    
    override init() {
        super.init()
    }
    
    
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        setTitle("")
        
        
        if let workoutManager = context as? WorkoutManager {
            self.workoutManager = workoutManager
            self.workout = workoutManager.workout
        } else {
            print("Context is not a Workout type.")
        }
        
        
        setImages()
        currentGroupLabel.setText(presentGroupInfo(currentGroup: self.workout!.currentGroup, totalGroup: self.workout!.totalGroup))
        
        currentWorkoutCountLabel.setText("0")
        durationLabel.setText("00:00")
        
        startProgressIndicator()  // Start Updating count and score
        
        workoutManager?.startWorkout()
        
    }
    
    override func willActivate() {
        super.willActivate()
    }
    
    override func didDeactivate() {
        super.didDeactivate()
    }
    
}

extension WorkoutProgressInterfaceController {
    func updateDuration() {
        let currentDate = Date().timeIntervalSinceReferenceDate
        let difference = Double(currentDate - (workoutManager?.workoutStartTime!.timeIntervalSinceReferenceDate)!)
        durationLabel.setText(durationFormatter.string(from: difference))
    }
    
    func startProgressIndicator() {
        // Reset progress and timer.
        updateTimer?.invalidate()

        // Schedule timer.
        updateTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateProgress), userInfo: nil, repeats: true)
    }

    @objc private func updateProgress() {
        if workoutManager?.session != nil {
            if workoutManager?.session.state == .running {
                updateDuration()
            }
        }
        
        if (workoutManager?.motionManager.isAccelerometerAvailable)! {
            workoutManager?.setCurrentRepeat()  // real-time count
            
            if workoutManager!.currentRepeat > self.lastCount {  // one more move recorded
                WKInterfaceDevice.current().play(WKHapticType.directionUp)
                let ratio = Int(workoutManager!.currentRepeat * 100 / workoutManager!.workout!.repeats)
                currentWorkoutCountGroup.setBackgroundImage(UIImage(named: "workout-count-\(ratio)"))
            }
            
            currentWorkoutCountLabel.setText(workoutManager?.currentRepeat.description)
            self.lastCount = workoutManager!.currentRepeat
        }
        
        if workoutManager!.currentRepeat >= workoutManager!.workout!.repeats {
            // TODO: add haptic
            updateTimer?.invalidate()  // kill current timer
            
            skipToNextGroup(controller: self, workoutManager: workoutManager!)
        } else {
            currentWorkoutCountLabel.setText(workoutManager?.currentRepeat.description)
        }
    }
}
