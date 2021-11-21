# FitPal

## Simple Goal
- Workout category classifier
- Moves Counter (for a specific category)

## Milestones
### **Service blueprint**
![Imgur](https://user-images.githubusercontent.com/82990245/142161676-a0adf4fe-1a88-4cd2-a6d5-e4931f7d69c0.png)

### **Data Collection Protocol**
* Setup
  * Make sure Apple Watch and iPhone are connected.
  * Leave at least 500MB free space on Apple Watch to log data.
  * Download [SensorLog](https://apps.apple.com/us/app/sensorlog/id388014573) on both iPhone and Apple Watch.
  * Set sampling rate on Apple Watch to 50Hz.
  * Trun off Battery and Core Location logging option.
  * Trun on device ID option.
* At Gym
  * Make sure tester is at his/her normal BPM level (rest for a certain time).
  * Make sure tester's Apple Watch runs SensorLog on foreground.
* Begin iteration
  * Start
    * Tester press the log button, set him/herself ready to do the task.
    * Wait for 10 seconds around (this is to stabilize accelerometer).
    * Start pushing/pulling/running etc.
    * Do at least 20 units of a specific category or 5 minutes if the category is uncountable.
  * End
    * Wait for a minute after finishing moves.
    * Tester presses finish logging after his/her BPM returns to normal level.
  * Continue
* End iteration


## TODO List
- [x] ~~Hello World~~
- [x] Product Service blueprint
  - [x] Built by [@Memeyun1](https://github.com/Memeyun1) and [@AsphaltC](https://github.com/AsphaltC).
  - [x] Edit here: [会议桌链接](https://desktop.huiyizhuo.com/1458414258500956162)
- [ ] iOS and companion Apple Watch app demo
  - [x] DDL: before Sunday!
  - [x] 11.17 built with ~~SwiftUI~~ Storyboard.
  - [x] On Apple Watch, call HealthKit to get HeartRate, energy burned data.
  - [x] Communicate with iOS app.
  - [ ] **On iOS app, present data with simple labels.**
  - [x] Also embed a button on Apple Watch app. When user cicks it, the Apple Watch would call ```playHaptic()``` (maybe other APIs..) to notify with a haptic vibration.
- [x] design the structure and process of data collection
  - [x] DDL: 11.18
  - [x] learn how to use [SensorLog](https://apps.apple.com/us/app/sensorlog/id388014573).
  - [x] develop the collection protocol.
- [x] two Apple Watches
  - [x] Apple Watch Series 7 45mm
  - [x] Apple Watch Series 7 41mm
- [ ] iOS frontend design
  - [ ] Lo-fi prototype
    - [ ] DDL: before before Saturday!
  - [ ] Hi-Fi prototype
- [ ] watchOS frontend design
  - [ ] Lo-fi prototype
    - [ ] DDL: before before Saturday!
  - [ ] Vibration feedback design
    - [x] design the functions and types
    - [ ] DDL: before before Saturday!
  - [ ] Hi-Fi prototype
- [ ] data collecting
- [ ] iOS, watchOS backend design
- [ ] build and train the model
- [ ] evaluate the model
- [ ] deployment to watchOS and iOS
- [ ] test
  - [ ] Model test
  - [ ] App test
  - [ ] User test
- [ ] concept videos & presentation ppt
- [ ] final report paper
