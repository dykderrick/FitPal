//
// Created by dykderrick on 2021/12/20.
//
// FitPal
//
// Copyright © 2021 Derrick Ding. All rights reserved.
//
	 

import Foundation


func presentWorkoutDuration(duration: Int) -> String {
    let minutes = Int(duration / 60)
    return "\(minutes)mins"
}

func presentWorkoutGroupCount(totalGroup: Int) -> String {
    return "\(totalGroup) groups"
}

func presentGroupInfo(currentGroup: Int, totalGroup: Int) -> String {
    return "\(currentGroup)/\(totalGroup)"
}
