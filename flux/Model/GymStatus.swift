//
//  GymStatus.swift
//  flux
//
//  Created by VICTOR CHU on 2018-03-20.
//  Copyright © 2018 Victor Chu. All rights reserved.
//

import Foundation

class GymStatus {
 static let instance = GymStatus()
    
    func determineStatus() {
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let day = calendar.component(.weekday, from: date)
        
        if hour == 13 && day == 3 {
            print("Not busy")
        }
    }
    
    
}
