//
//  ViewController.swift
//  flux
//
//  Created by VICTOR CHU on 2018-03-19.
//  Copyright © 2018 Victor Chu. All rights reserved.
//

import UIKit
import Motion

class LaunchVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Delays screen to show launch screen longer.
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            // Check the current time and day of week to determine busy status, then display corresponding status
            // if ......
            
            let navVC = self.storyboard?.instantiateViewController(withIdentifier: "NavigationVC")
            navVC!.modalTransitionStyle = .crossDissolve
            self.present(navVC!, animated: true, completion: nil)
        }
    }




}

