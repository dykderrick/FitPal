//
// Created by dykderrick on 2021/12/17.
//
// FitPal
//
// Copyright © 2021 Derrick Ding. All rights reserved.
//
	 

import WatchKit
import Foundation


class TableRowController: NSObject {
    @IBOutlet weak var workoutInfoGroup: WKInterfaceGroup!
    @IBOutlet weak var workoutTypeLabel: WKInterfaceLabel!
    @IBOutlet weak var workoutTotalGroupLabel: WKInterfaceLabel!
    @IBOutlet weak var workoutImageView: WKInterfaceImage!
    @IBOutlet weak var workoutStartButton: WKInterfaceButton!

    
    // Invoked when WorkoutSelectionController willActivate()
    func showItem(workoutType: String, workoutTime: String) {  // TODO: miss ImageView field
        workoutTypeLabel.setText(workoutType)
        workoutTotalGroupLabel.setText(workoutTime)
    }
}
