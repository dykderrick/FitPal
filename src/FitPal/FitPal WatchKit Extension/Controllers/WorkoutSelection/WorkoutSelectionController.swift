//
// Created by dykderrick on 2021/12/17.
//
// FitPal
//
// Copyright © 2021 Derrick Ding. All rights reserved.
//
	 

import UIKit
import WatchKit
import Foundation


let workoutTypeItem = "type"
let workoutTimeItem = "time"


class WorkoutSelectionController: WKInterfaceController {
    
    @IBOutlet weak var table: WKInterfaceTable!
    var workouts = [Workout]()
    
    private func loadTableData() {
        table.setNumberOfRows(workouts.count, withRowType: "Cell")
        
        var j = 0
        for workout in workouts {
            let row = table.rowController(at: j) as! TableRowController
            row.showItem(workoutType: workout.name, workoutTime: presentWorkoutGroupCount(totalGroup: workout.totalGroup))
            
            j += 1
        }
        
    }
    
    override init() {
        super.init()
        
        workouts.append(Workout(id: 0, name: "Bench Press", accelerometerCoordinate: 0, checkInterval: 40, correlationThreshold: 6.5, segmentationThreshold: 0.2, currentGroup: 1, totalGroup: 4, repeats: 10))
        workouts.append(Workout(id: 1, name: "Russian Twist", accelerometerCoordinate: 0, checkInterval: 40, correlationThreshold: 13.0, segmentationThreshold: 0.15, currentGroup: 1, totalGroup: 4, repeats: 10))
        workouts.append(Workout(id: 2, name: "Barbell Rowing", accelerometerCoordinate: 0, checkInterval: 40, correlationThreshold: 1.7, segmentationThreshold: 0.15, currentGroup: 1, totalGroup: 4, repeats: 10))
        workouts.append(Workout(id: 3, name: "Pec Fly", accelerometerCoordinate: 2, checkInterval: 40, correlationThreshold: 2.0, segmentationThreshold: 0.25, currentGroup: 1, totalGroup: 4, repeats: 10))
    }
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        setTitle("")
        
        // Request HealthKit authorization
        HealthStore().requestAuthorization { success in

        }
        
    }
    
    override func willActivate() {
        super.willActivate()
        
        loadTableData()
    }
    
    override func didDeactivate() {
        super.didDeactivate()
    }
    
    // TODO: Table Controller
    override func table(_ table: WKInterfaceTable, didSelectRowAt rowIndex: Int) {
        print("Did Select Row At \(rowIndex)")
        
        
        presentController(withName: "Countdown", context: WorkoutManager(workout: workouts[rowIndex]))
    }
}
