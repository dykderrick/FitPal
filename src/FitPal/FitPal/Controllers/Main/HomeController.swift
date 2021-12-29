//
// Created by dykderrick on 2021/12/9.
//
// FitPal
//
// Copyright © 2021 Derrick Ding. All rights reserved.
//
	 

import UIKit

class HomeController: UIViewController {
    var healthStore = HealthStore()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // request HealthKit authorization
        healthStore.requestAuthorization { success in
            
        }
        
        
    }
    
    
    
}
