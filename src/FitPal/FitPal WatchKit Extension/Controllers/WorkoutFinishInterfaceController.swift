//
// Created by dykderrick on 2021/12/18.
//
// FitPal
//
// Copyright © 2021 Derrick Ding. All rights reserved.
//
	 

import Foundation
import WatchKit
import HealthKit

class WorkoutFinishInterfaceController: WKInterfaceController {
    @IBOutlet weak var energyLabel: WKInterfaceLabel!
    @IBOutlet weak var timeLabel: WKInterfaceLabel!
    @IBOutlet weak var actionLabel: WKInterfaceLabel!
    
    
    var workoutManager: WorkoutManager?
    
    
    fileprivate func setLabels(_ totalEnergyBurnedInt: Int) {
        energyLabel.setText(totalEnergyBurnedInt.description)
        timeLabel.setText(durationFormatter.string(from: workoutManager?.hkWorkoutData?.duration ?? 0.0))
        actionLabel.setText(workoutManager?.workout?.currentGroup.description)
    }
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        setTitle("")
        
        WKInterfaceDevice.current().play(WKHapticType.success)
        
        
        if let workoutManager = context as? WorkoutManager {
            self.workoutManager = workoutManager
        } else {
            print("Context is not a Workout type.")
        }
    }
    
    override func willActivate() {
        super.willActivate()
        
        let totalEnergyBurnedInt = Int(workoutManager?.hkWorkoutData?.totalEnergyBurned?.doubleValue(for: HKUnit.kilocalorie()) ?? 0.0)
        
        setLabels(totalEnergyBurnedInt)
    }
    
    override func didDeactivate() {
        super.didDeactivate()
    }
    
}
