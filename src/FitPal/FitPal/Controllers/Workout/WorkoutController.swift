//
// Created by dykderrick on 2021/12/15.
//
// FitPal
//
// Copyright © 2021 Derrick Ding. All rights reserved.
//
	 

import UIKit
import HealthKit

class WorkoutController: UIViewController {
    
    @IBOutlet weak var startWorkoutDemoButton: UIButton!
    
    
    
    
    
    
    
    @IBAction func startWorkoutDemoButtonClicked() {
        startWatchWorkout()
        
    }
    

    
    
    func startWatchWorkout() {
        WatchConnectivityManager.shared.sendParamsToWatch(dictData: [
            "id": UUID().uuidString,
            "workoutType": "Pec Fly"  // TODO: Remove hard-code
            // TODO: Maybe add other parameters like period, time etc.
        ])
        
        
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    
    
    
}
