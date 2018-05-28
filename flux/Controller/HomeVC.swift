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
    
    var mondayDictionary = [String: Double]()
    var tuesdayDictionary = [String: Double]()
    var wednesdayDictionary = [String: Double]()
    var thursdayDictionary = [String: Double]()
    var fridayDictionary = [String: Double]()
    var saturdayDictionary = [String: Double]()
    var sundayDictionary = [String: Double]()
    
    var hourOfDay = [String]()
    var numberOfEntriesArray = [Double]()
   

    

    override func viewDidLoad() {
        
        hourOfDay = ["8:00", "9:00", "10:00", "11:00", "12:00", "1:00", "2:00", "3:00", "4:00", "5:30"]
        
        super.viewDidLoad()
        refreshControl.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
        scrollView.addSubview(refreshControl)
        addNavigationBarTitleImage()
        retrieveData(Day: determineDay())
        
    }
    
    
    func barChartProperties() {
        barChart.chartDescription?.text = ""
        barChart.rightAxis.enabled = false
        barChart.xAxis.drawGridLinesEnabled = false
        barChart.xAxis.labelPosition = .bottom
        barChart.xAxis.centerAxisLabelsEnabled = true
        barChart.doubleTapToZoomEnabled = false

        
        
    }
    


    

    
    func retrieveData(Day: String) {
        
        // Set the firebase reference
        ref = Database.database().reference().child("charts").child(Day)
        
        if Day == "monday" {
            ref?.observeSingleEvent(of: .value, with: { (snapshot) in
                
                for child in snapshot.children {
                    let snap = child as! DataSnapshot
                    let key = snap.key
                    let value = snap.value as! Double
                    
                    self.mondayDictionary[key] = value
                    //self.hourOfDay.append(key)
                    self.numberOfEntriesArray.append(value)
                    
                    print(self.mondayDictionary[key]!)
                    
                    print("key = \(key) value = \(value)")
                }
            })
        }
        
        else if Day == "tuesday" {
            ref?.observeSingleEvent(of: .value, with: { (snapshot) in
                
                for child in snapshot.children {
                    let snap = child as! DataSnapshot
                    let key = snap.key
                    let value = snap.value as! Double
                    
                    self.tuesdayDictionary[key] = value
                    
                    print(self.tuesdayDictionary[key]!)
                    
                    print("key = \(key) value = \(value)")
                }
            })
        }
        
        else if Day == "wednesday" {
            ref?.observeSingleEvent(of: .value, with: { (snapshot) in
                
                for child in snapshot.children {
                    let snap = child as! DataSnapshot
                    let key = snap.key
                    let value = snap.value as! Double
                    
                    self.wednesdayDictionary[key] = value
                    
                    print(self.wednesdayDictionary[key]!)
                    
                    print("key = \(key) value = \(value)")
                }
            })
        }
        
        else if Day == "thursday" {
            ref?.observeSingleEvent(of: .value, with: { (snapshot) in
                
                for child in snapshot.children {
                    let snap = child as! DataSnapshot
                    let key = snap.key
                    let value = snap.value as! Double
                    
                    self.thursdayDictionary[key] = value
                    
                    print(self.thursdayDictionary[key]!)
                    
                    print("key = \(key) value = \(value)")
                }
            })
        }
        
        else if Day == "friday" {
            ref?.observeSingleEvent(of: .value, with: { (snapshot) in
                
                for child in snapshot.children {
                    let snap = child as! DataSnapshot
                    let key = snap.key
                    let value = snap.value as! Double
                    
                    self.fridayDictionary[key] = value
                    
                    print(self.fridayDictionary[key]!)
                    
                    print("key = \(key) value = \(value)")
                    
                }
                

            })
        }
        
        else if Day == "saturday" {
            ref?.observeSingleEvent(of: .value, with: { (snapshot) in
                
                for child in snapshot.children {
                    let snap = child as! DataSnapshot
                    let key = snap.key
                    let value = snap.value as! Double
                    
                    self.saturdayDictionary[key] = value
                    
                    print(self.saturdayDictionary[key]!)
                    
                    print("key = \(key) value = \(value)")
                }
            })
        }
        
        else {
            ref?.observeSingleEvent(of: .value, with: { (snapshot) in
                
                let groupKeys = snapshot.children.compactMap { $0 as? DataSnapshot }.map { $0.key }
                
                // This group will keep track of the number of blocks still pending
                let group = DispatchGroup()
                
                for child in snapshot.children {
                    let snap = child as! DataSnapshot
                    let key = snap.key
                    let value = snap.value as! Double
                    
                    self.sundayDictionary[key] = value
                   // self.hourOfDay.append(key)
                    self.numberOfEntriesArray.append(value)
                    
                    
                    print(self.sundayDictionary[key]!)
                    
                    print("key = \(key) value = \(value)")
                }
                
                for groupKey in groupKeys {
                    group.enter()
                    self.ref?.child("groups").child(groupKey).child("name").observeSingleEvent(of: .value, with: { snapshot in
                        group.leave()
                    })
                }
                
                // We ask to be notified when every block left the group
                group.notify(queue: .main) {
                    print("All callbacks are completed")
                    self.barChart.setBarChartData(xValues: self.hourOfDay, yValues: self.numberOfEntriesArray, label: "Number of Entries")
                    self.barChart.xAxis.setLabelCount(10, force: true)
                    self.barChartProperties()

                }
            })
        }
        
        
    }
    
    @objc func didPullToRefresh() {
        numberOfEntriesArray.removeAll()
        retrieveData(Day: determineDay())
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

extension BarChartView {
    
    private class BarChartFormatter: NSObject, IAxisValueFormatter {
        
        var labels: [String] = []
        
        func stringForValue(_ value: Double, axis: AxisBase?) -> String {
            
            return labels[Int(value)]
        }
        
        init(labels: [String]) {
            super.init()
            self.labels = labels
        }
    }
    
    func setBarChartData(xValues: [String], yValues: [Double], label: String) {
        
        var dataEntries: [BarChartDataEntry] = []
        
        for i in 0..<yValues.count {
            let dataEntry = BarChartDataEntry(x: Double(i), y: yValues[i])
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = BarChartDataSet(values: dataEntries, label: label)
        let chartData = BarChartData(dataSet: chartDataSet)
        
        let chartFormatter = BarChartFormatter(labels: xValues)
        let xAxis = XAxis()
        xAxis.valueFormatter = chartFormatter
        self.xAxis.valueFormatter = xAxis.valueFormatter
        
        self.data = chartData
    }
}





