//
//  MainVC.swift
//  flux
//
//  Created by VICTOR CHU on 2018-03-19.
//  Copyright © 2018 Victor Chu. All rights reserved.
//

import UIKit
import Charts
import FirebaseDatabase

class HomeVC: UIViewController, ChartViewDelegate {

    @IBOutlet weak var statusLabel: UIImageView!
    @IBOutlet weak var statusDescriptionLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var barChart: BarChartView!
    
    let refreshControl = UIRefreshControl()
    
    var ref:DatabaseReference?
    var refHandle: UInt?
    
    var mondayArray = [String: Int]()

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshControl.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
        scrollView.addSubview(refreshControl)
        addNavigationBarTitleImage()
        retrieveData(Day: determineDay())
        
        
    }

    
    func retrieveData(Day: String) {
        
        // Set the firebase reference
        ref = Database.database().reference().child("charts").child("monday")
        
        ref?.observeSingleEvent(of: .value, with: { (snapshot) in
            
            for child in snapshot.children {
                let snap = child as! DataSnapshot
                let key = snap.key
                let value = snap.value as! Int
                
                self.mondayArray[key] = value
                
                print(self.mondayArray[key]!)
                
                print("key = \(key) value = \(value)")
            }
        })
    
    }
    
    @objc func didPullToRefresh() {
        //determineGymStatus()
        refreshControl.endRefreshing()
    }
    
    
 
    
    func determineDay() -> String {
        let date = Date()
        let calendar = Calendar.current
        let day = calendar.component(.weekday, from: date)
        var value = ""
        
        if day == 1 {
            value = "sunday"
        } else if day == 2 {
            value = "monday"
        } else if day == 3 {
            value = "tuesday"
        } else if day == 4 {
            value = "wednesday"
        } else if day == 5 {
            value = "thursday"
        } else if day == 6 {
            value = "friday"
        } else {
            value = "saturday"
        }
        
        return value
    }
    
    
    func addNavigationBarTitleImage() {
        let titleImageView = UIImageView(image: #imageLiteral(resourceName: "FluxNavBarIcon"))
        titleImageView.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
        titleImageView.contentMode = .scaleAspectFit
        
        navigationItem.titleView = titleImageView
    }
    
//    func lowStatus() {
//        statusImage.image = #imageLiteral(resourceName: "NotBusyBar")
//        statusDescriptionLabel.text = "Currently the gym is not busy."
//    }
//
//    func moderateStatus() {
//        statusImage.image = #imageLiteral(resourceName: "ModerateBusyBar")
//        statusDescriptionLabel.text = "Currently the gym moderately busy."
//    }
//
//    func highStatus() {
//        statusImage.image = #imageLiteral(resourceName: "HighBusyBar")
//        statusDescriptionLabel.text = "Currently the gym is busy."
//    }


    @IBAction func customTimeButtonTapped(_ sender: Any) {

    }
    
}






