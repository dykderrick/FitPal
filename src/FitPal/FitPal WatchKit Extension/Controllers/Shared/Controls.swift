//
// Created by dykderrick on 2021/12/23.
//
// FitPal
//
// Copyright © 2021 Derrick Ding. All rights reserved.
//
	 

import Foundation
import WatchKit

func skipToNextGroup(controller: WKInterfaceController, workoutManager: WorkoutManager) {
    if workoutManager.workout?.currentGroup == workoutManager.workout?.totalGroup {  // skip at last group
        workoutManager.stopWorkout()
        WKInterfaceController().presentController(withName: "Loading", context: workoutManager)
    } else {
        // We'll put currentGroup += 1 in BreathoutInterfaceController.swift
        // When breathout, CoreMotionManager will be stopped and reset but WorkoutSession will not be paused.
        if workoutManager.motionManager.isAccelerometerAvailable {
            workoutManager.fireRecordingAccelarations()  // Stop recording accelarations
        }
        controller.presentController(withNames: ["Breathout", "NowPlaying"], contexts: [workoutManager as Any, workoutManager as Any])
    }
}


var durationFormatter: DateComponentsFormatter = {
    let formatter = DateComponentsFormatter()
    formatter.allowedUnits = [.minute, .second]
    formatter.zeroFormattingBehavior = .pad
    return formatter
}()
