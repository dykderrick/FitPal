//
// Created by dykderrick on 2021/12/15.
//
// FitPal
//
// Copyright © 2021 Derrick Ding. All rights reserved.
//
	 

import Foundation
import HealthKit
import HealthKit
import CoreMotion

class WorkoutManager: NSObject, ObservableObject {
    var workout: Workout?
    
    var selectedWorkoutType: HKWorkoutActivityType = .traditionalStrengthTraining
    var locationType: HKWorkoutSessionLocationType = .indoor  // TODO: remove hard-code
    var session: HKWorkoutSession!
    var builder: HKLiveWorkoutBuilder!
    var healthStoreObject = HealthStore()  // HealthStore.swift in FitPal/Models
    let motionManager = CMMotionManager()
    
    var workoutStartTime: Date?
    var isWorkingout = false
    var realTimeHeartRate = 0
    
    var currentRepeat = 0
//    var currentScore = 0
    var coorelationScores: [Double] = []
    
    var accelarations: [[Double]] = [[], [], []]  // in [[xs], [ys], [zs]]
    
    var hkWorkoutData: HKWorkout?  // Results
    
    init(workout: Workout) {
        self.workout = workout
    }
    
    fileprivate func initWorkout() {
        let configuration = HKWorkoutConfiguration()
        configuration.activityType = selectedWorkoutType
        configuration.locationType = locationType
        
        
        do {
            session = try HKWorkoutSession(healthStore: healthStoreObject.healthStore!, configuration: configuration)
            builder = session.associatedWorkoutBuilder()
        } catch {
            fatalError("Unable to start a workout session.")
        }
        
        session.delegate = self
        builder.delegate = self
        
        builder.dataSource = HKLiveWorkoutDataSource(healthStore: healthStoreObject.healthStore!, workoutConfiguration: configuration)
    }
    
    
    func startWorkout() {
        initWorkout()
        
        isWorkingout = true
        
        // Deal with workout session and builder
        let date = Date()
        session.startActivity(with: date)  // you should set the workout’s startDate to the iOS workout’s start
        builder.beginCollection(withStart: date) { (succ, error) in
            if succ {
                self.workoutStartTime = date  // log workout start time
            } else {
                fatalError("Error beginning collection from builder: \(String(describing: error)))")
            }
        }
        
        // Deal with accelerometer data
        if motionManager.isAccelerometerAvailable {
            let handler:CMAccelerometerHandler = {(data: CMAccelerometerData?, error: Error?) -> Void in
                //self.xAccValueLabel.setText(String(format: "%.2f", data!.acceleration.x))
                //self.yAccValueLabel.setText(String(format: "%.2f", data!.acceleration.y))
                //self.zAccValueLabel.setText(String(format: "%.2f", data!.acceleration.z))
                self.accelarations[0].append(data!.acceleration.x)
                self.accelarations[1].append(data!.acceleration.y)
                self.accelarations[2].append(data!.acceleration.z)
            }
            motionManager.startAccelerometerUpdates(to: OperationQueue.current!, withHandler: handler)
        } else {
            //xAccValueLabel.setText("not available")
            //yAccValueLabel.setText("not available")
            //zAccValueLabel.setText("not available")
        }
        
    }
    
    func pauseWorkout() {
        if isWorkingout {
            isWorkingout = false
            session.pause()
            motionManager.stopAccelerometerUpdates()
        }
    }
    

    
    func resumeWorkout() {
        if !isWorkingout {
            session.resume()
            
            startRecordingAccelarations()

            isWorkingout = true
        }
    }
    
    func stopWorkout() {
        motionManager.stopAccelerometerUpdates()
        
        session?.end()
    }
    
    func startRecordingAccelarations() {
        // Deal with accelerometer data
        if motionManager.isAccelerometerAvailable {
            let handler:CMAccelerometerHandler = {(data: CMAccelerometerData?, error: Error?) -> Void in
                self.accelarations[0].append(data!.acceleration.x)
                self.accelarations[1].append(data!.acceleration.y)
                self.accelarations[2].append(data!.acceleration.z)
            }
            motionManager.startAccelerometerUpdates(to: OperationQueue.current!, withHandler: handler)
        } else {
            //xAccValueLabel.setText("not available")
            //yAccValueLabel.setText("not available")
            //zAccValueLabel.setText("not available")
        }
    }
    
    
    /// This function stops the accelerometer data recording
    /// by calling ```CMMotionManager.stopAccelerometerUpdates()```
    /// and then resets ```accelarations```
    /// and ```coorelationScores```
    /// array to vacant, and currentRepeat to zero.
    ///
    /// ```
    /// fireRecordingAccelarations()
    /// ```
    ///
    func fireRecordingAccelarations() {
        motionManager.stopAccelerometerUpdates()
        accelarations = [[], [], []]  // Reset
        currentRepeat = 0
        coorelationScores = []
    }
    
}


extension WorkoutManager {
    /// Put current accelarations data and parameters to ```getSegmentationNumAndCorrelations()```,
    /// and update ```currentRepeat``` with newest calculated value.
    func setCurrentRepeat() {
        let segStart = workout!.checkInterval
        if self.accelarations != [] {
            if self.accelarations[0].count > segStart {
                var segmentationNum = 0
                (segmentationNum, self.coorelationScores) = getSegmentationNumAndCorrelations(accelerometer: accelarations[workout!.accelerometerCoordinate], segStart: segStart, segThreshold: workout!.segmentationThreshold, truth: truths[workout!.name]!)
                
                if segmentationNum >= 2 {
                    self.currentRepeat = self.coorelationScores.filter { $0 > workout!.correlationThreshold }.count
                }
            }
        }
    }
}


extension WorkoutManager: HKWorkoutSessionDelegate {
    func workoutSession(_ workoutSession: HKWorkoutSession, didChangeTo toState: HKWorkoutSessionState, from fromState: HKWorkoutSessionState, date: Date) {
        print("[workoutSession] Changed State: \(toState.rawValue)")
        
        // Wait for the session to transition states before ending the builder.
        if toState == .ended {
            builder.endCollection(withEnd: Date()) { (success, error) in
                self.builder.finishWorkout { (workout, error) in
                    DispatchQueue.main.async() {
                        self.hkWorkoutData = workout
                        self.session = nil
                        self.builder = nil
                        self.accelarations = []
                    }
                }
            }
        }
    }
    
    func workoutSession(_ workoutSession: HKWorkoutSession, didFailWithError error: Error) {
        print("[workoutSession] Encountered an error: \(error)")
    }
}


extension WorkoutManager: HKLiveWorkoutBuilderDelegate {
    func workoutBuilder(_ workoutBuilder: HKLiveWorkoutBuilder, didCollectDataOf collectedTypes: Set<HKSampleType>) {
        for type in collectedTypes {
            guard let quantityType = type as? HKQuantityType else {
                return
            }
            let statistics = workoutBuilder.statistics(for: quantityType)
            
            switch quantityType {
            case HKQuantityType.quantityType(forIdentifier: .heartRate):
                let heartRateUnit = HKUnit.count().unitDivided(by: HKUnit.minute())
                let valueHR = statistics!.mostRecentQuantity()?.doubleValue(for: heartRateUnit)
                let stringValueHR = String(Int(Double(round(1 * valueHR!) / 1)))
                realTimeHeartRate = Int(Double(round(1 * valueHR!) / 1))  // set class variable
                print("[workoutBuilder] Heart Rate: \(stringValueHR)")
            case HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned):
                let energyUnit = HKUnit.kilocalorie()
                let valueAEB = statistics!.sumQuantity()?.doubleValue(for: energyUnit) ?? 0
                let stringValueAEB = String(valueAEB)
                print("[workoutBuilder] Active Energy Burned: \(stringValueAEB)")
            default:
                return
            }
        }
    }
    
    func workoutBuilderDidCollectEvent(_ workoutBuilder: HKLiveWorkoutBuilder) {
        // Retreive the workout event.
        guard let workoutEventType = workoutBuilder.workoutEvents.last?.type else { return }
        print("[workoutBuilderDidCollectEvent] Workout Builder changed event: \(workoutEventType.rawValue)")
    }
}
