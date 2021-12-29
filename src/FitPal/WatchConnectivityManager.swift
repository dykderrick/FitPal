//
// Created by dykderrick on 2021/12/16.
//
// FitPal
//
// Copyright © 2021 Derrick Ding. All rights reserved.
//
	 

import Foundation
import WatchConnectivity

class WatchConnectivityManager: NSObject {
    static let shared: WatchConnectivityManager = WatchConnectivityManager()
    fileprivate var watchConnectivitySession: WCSession?
    
    override init() {
        super.init()
        
        if (!WCSession.isSupported()) {
            // handle unsupported watch connectivity
            // TODO: Maybe change it to exit the app
            
            watchConnectivitySession = nil
            return
        }
        watchConnectivitySession = WCSession.default
        watchConnectivitySession?.delegate = self
        watchConnectivitySession?.activate()
    }
    
    func sendParamsToWatch(dictData: [String: Any]) {
        do {
            try watchConnectivitySession?.updateApplicationContext(dictData)
        } catch {
            print("Error Updating Application Context \(dictData) to Apple Watch")
        }
    }
}


extension WatchConnectivityManager: WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("Activation Did Complete.")
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        print("Activation Did Become Inactive.")
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        print("Activation Did Deactivate.")
    }
}
