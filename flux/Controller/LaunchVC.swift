//
//  ViewController.swift
//  flux
//
//  Created by VICTOR CHU on 2018-03-19.
//  Copyright © 2018 Victor Chu. All rights reserved.
//

import UIKit

class LaunchVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Delays screen to show launch screen longer.
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            let tabBarVC = self.storyboard?.instantiateViewController(withIdentifier: "TabBarVC")
            self.present(tabBarVC!, animated: true, completion: nil)
        }
    }




}

