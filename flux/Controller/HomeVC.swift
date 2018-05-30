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

    @IBOutlet weak var lineChartView: LineChartView!
    @IBOutlet weak var currentStatusImage: UIImageView!
    
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
        super.viewDidLoad()
        retrieveData(Day: determineDay())
        
    }
    @IBAction func reloadButtonTapped(_ sender: Any) {
        numberOfEntriesArray.removeAll()
        retrieveData(Day: determineDay())
     }
    
    func lineChartProperties() {
        lineChartView.chartDescription?.text = ""
        lineChartView.doubleTapToZoomEnabled = false
        lineChartView.xAxis.drawAxisLineEnabled = false
        lineChartView.leftAxis.drawGridLinesEnabled = false
        lineChartView.leftAxis.drawLabelsEnabled = false
        lineChartView.leftAxis.drawAxisLineEnabled = false
        lineChartView.rightAxis.drawGridLinesEnabled = false
        lineChartView.rightAxis.drawLabelsEnabled = false
        lineChartView.rightAxis.drawAxisLineEnabled = false
        lineChartView.legend.enabled = false
        lineChartView.backgroundColor = #colorLiteral(red: 0.9764705882, green: 0.9764705882, blue: 0.9764705882, alpha: 1)
        lineChartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
    }

    
    func retrieveData(Day: String) {
        
        // Set the firebase reference
        ref = Database.database().reference().child("charts").child(Day)
        
        if Day == "monday" {
            ref?.observeSingleEvent(of: .value, with: { (snapshot) in
                
                let groupKeys = snapshot.children.compactMap { $0 as? DataSnapshot }.map { $0.key }
                
                // This group will keep track of the number of blocks still pending
                let group = DispatchGroup()
                
                for child in snapshot.children {
                    let snap = child as! DataSnapshot
                    let key = snap.key
                    let value = snap.value as! Double
                    
                    self.mondayDictionary[key] = value
                    // self.hourOfDay.append(key)
                    self.numberOfEntriesArray.append(value)
                    
                    
                    print(self.mondayDictionary[key]!)
                    
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

                    self.lineChartProperties()
                    self.lineChartView.setBarChartData(xValues: self.hourOfDay, yValues: self.numberOfEntriesArray, label: "Number of Entries")
                }
            })
        
        }
        
        else if Day == "tuesday" {
            ref?.observeSingleEvent(of: .value, with: { (snapshot) in
                
                let groupKeys = snapshot.children.compactMap { $0 as? DataSnapshot }.map { $0.key }
                
                // This group will keep track of the number of blocks still pending
                let group = DispatchGroup()
                
                for child in snapshot.children {
                    let snap = child as! DataSnapshot
                    let key = snap.key
                    let value = snap.value as! Double
                    
                    self.tuesdayDictionary[key] = value
                    // self.hourOfDay.append(key)
                    self.numberOfEntriesArray.append(value)
                    
                    
                    print(self.tuesdayDictionary[key]!)
                    
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
                    
                    self.lineChartProperties()
                    self.lineChartView.setBarChartData(xValues: self.hourOfDay, yValues: self.numberOfEntriesArray, label: "Number of Entries")
                    
                }
            })
            
        }
        
        else if Day == "wednesday" {
            ref?.observeSingleEvent(of: .value, with: { (snapshot) in
                
                let groupKeys = snapshot.children.compactMap { $0 as? DataSnapshot }.map { $0.key }
                
                // This group will keep track of the number of blocks still pending
                let group = DispatchGroup()
                
                for child in snapshot.children {
                    let snap = child as! DataSnapshot
                    let key = snap.key
                    let value = snap.value as! Double
                    
                    self.wednesdayDictionary[key] = value
                    // self.hourOfDay.append(key)
                    self.numberOfEntriesArray.append(value)
                    
                    
                    print(self.wednesdayDictionary[key]!)
                    
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
                    
                    self.lineChartProperties()
                    self.lineChartView.setBarChartData(xValues: self.hourOfDay, yValues: self.numberOfEntriesArray, label: "Number of Entries")
                    
                }
            })
        }
        
        else if Day == "thursday" {
            ref?.observeSingleEvent(of: .value, with: { (snapshot) in
                
                let groupKeys = snapshot.children.compactMap { $0 as? DataSnapshot }.map { $0.key }
                
                // This group will keep track of the number of blocks still pending
                let group = DispatchGroup()
                
                for child in snapshot.children {
                    let snap = child as! DataSnapshot
                    let key = snap.key
                    let value = snap.value as! Double
                    
                    self.thursdayDictionary[key] = value
                    // self.hourOfDay.append(key)
                    self.numberOfEntriesArray.append(value)
                    
                    
                    print(self.thursdayDictionary[key]!)
                    
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
                    self.lineChartProperties()
                    self.lineChartView.setBarChartData(xValues: self.hourOfDay, yValues: self.numberOfEntriesArray, label: "Number of Entries")
                    
                }
            })
        }
        
        else if Day == "friday" {
            ref?.observeSingleEvent(of: .value, with: { (snapshot) in
                
                let groupKeys = snapshot.children.compactMap { $0 as? DataSnapshot }.map { $0.key }
                
                // This group will keep track of the number of blocks still pending
                let group = DispatchGroup()
                
                for child in snapshot.children {
                    let snap = child as! DataSnapshot
                    let key = snap.key
                    let value = snap.value as! Double
                    
                    self.fridayDictionary[key] = value
                    // self.hourOfDay.append(key)
                    self.numberOfEntriesArray.append(value)
                    
                    
                    print(self.fridayDictionary[key]!)
                    
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
                    self.lineChartProperties()
                    self.lineChartView.setBarChartData(xValues: self.hourOfDay, yValues: self.numberOfEntriesArray, label: "Number of Entries")
                    
                }
            })
        }
        
        else if Day == "saturday" {
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
                    
                    
                    print(self.saturdayDictionary[key]!)
                    
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
                    self.lineChartProperties()
                    self.lineChartView.setBarChartData(xValues: self.hourOfDay, yValues: self.numberOfEntriesArray, label: "Number of Entries")
                    
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
                    self.lineChartProperties()
                    self.lineChartView.setBarChartData(xValues: self.hourOfDay, yValues: self.numberOfEntriesArray, label: "Number of Entries")

                }
            })
        }
        
        
    }
    

    
    
 
    
    func determineDay() -> String {
        let date = Date()
        let calendar = Calendar.current
        let day = calendar.component(.weekday, from: date)
        var value = ""
        
        if day == 1 {
            hourOfDay = ["8:00", "9:00", "10:00", "11:00", "12:00", "1:00", "2:00", "3:00", "4:00", "5:30"]
            value = "sunday"
        }
        
        else if day == 2 {
            hourOfDay = ["6","7","8", "9", "10", "11", "12", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10"]
            value = "monday"
        }
        
        else if day == 3 {
            hourOfDay = ["6:00","7:00","8:00", "9:00", "10:00", "11:00", "12:00", "1:00", "2:00", "3:00", "4:00", "5:00", "6:00", "7:00", "8:00", "9:00", "10:00"]
            value = "tuesday"
        }
        
        else if day == 4 {
            hourOfDay = ["6:00","7:00","8:00", "9:00", "10:00", "11:00", "12:00", "1:00", "2:00", "3:00", "4:00", "5:00", "6:00", "7:00", "8:00", "9:00", "10:00"]
            value = "wednesday"
        }
        
        else if day == 5 {
            hourOfDay = ["6:00","7:00","8:00", "9:00", "10:00", "11:00", "12:00", "1:00", "2:00", "3:00", "4:00", "5:00", "6:00", "7:00", "8:00", "9:00", "10:00"]
            value = "thursday"
        }
        
        else if day == 6 {
            hourOfDay = ["6:00","7:00","8:00", "9:00", "10:00", "11:00", "12:00", "1:00", "2:00", "3:00", "4:00", "5:00", "6:00", "7:00", "8:00"]
            value = "friday"
        }
        
        else {
            hourOfDay = ["8:00", "9:00", "10:00", "11:00", "12:00", "1:00", "2:00", "3:00", "4:00", "5:30"]
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



    
}

extension LineChartView {
    
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
        
        var dataEntries: [ChartDataEntry] = []
        
        for i in 0..<yValues.count {
            let dataEntry = BarChartDataEntry(x: Double(i), y: yValues[i])
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = LineChartDataSet(values: dataEntries, label: label)
        let chartData = LineChartData(dataSet: chartDataSet)
        
        let chartFormatter = BarChartFormatter(labels: xValues)
        let xAxis = XAxis()
        xAxis.valueFormatter = chartFormatter
        self.xAxis.valueFormatter = xAxis.valueFormatter
        
        // Line chart color gradient
        let coloTop = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1).cgColor
        let colorBottom = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1).cgColor
        let gradientColors = [coloTop, colorBottom] as CFArray // Colors of the gradient
        let colorLocations:[CGFloat] = [0.7, 0.0] // Positioning of the gradient
        let gradient = CGGradient.init(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: gradientColors, locations: colorLocations) // Gradient Object
        chartDataSet.fill = Fill.fillWithLinearGradient(gradient!, angle: 90.0) // Set the Gradient
        chartDataSet.drawFilledEnabled = true // Draw the Gradient
        
        chartData.setDrawValues(false)
        chartDataSet.drawCirclesEnabled = false
        chartDataSet.mode = .cubicBezier

        
        self.data = chartData

    }
}





