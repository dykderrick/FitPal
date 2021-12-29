//
// Created by dykderrick on 2021/12/20.
//
// FitPal
//
// Copyright © 2021 Derrick Ding. All rights reserved.
//
	 

import Foundation


struct Workout: Identifiable {
    var id: Int
    var name: String
    
    var accelerometerCoordinate: Int  // 0->x, 1->y, 2->z
    var checkInterval: Int
    var correlationThreshold: Double
    var segmentationThreshold: Double
    
    var currentGroup: Int
    var totalGroup: Int  // how many groups
    var repeats: Int  // how many repeats in a single group; TODO: currently each group has the same amount of repeats
}
