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
import SimpleAnimation
import PopupDialog

class HomeVC: UIViewController, ChartViewDelegate {

    @IBOutlet weak var lineChartView: LineChartView!
    
    @IBOutlet weak var reloadButton: UIButton!
    @IBOutlet weak var arrowImage: UIImageView!
    @IBOutlet weak var busyStatusImage: UIImageView!
    @IBOutlet weak var nextHourEntriesLabel: UILabel!
    @IBOutlet weak var currentEntriesLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    var ref:DatabaseReference?
    var timer = Timer()
    
    var hourOfDay = [String]()
    var numberOfEntriesArray = [Double]()
    
    var dayDictionary = [String: Double]()

    override func viewDidLoad() {
        super.viewDidLoad()
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector:#selector(self.tick) , userInfo: nil, repeats: true)
        addNavigationBarTitleImage()
        retrieveDataForDay(Day: determineDay())

    }
    
    //MARK: - Misc.
    
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
        lineChartView.setScaleEnabled(false)
        lineChartView.xAxis.labelTextColor = #colorLiteral(red: 0.8374180198, green: 0.8374378085, blue: 0.8374271393, alpha: 1)
        lineChartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
    }
    
    func addNavigationBarTitleImage() {
        let titleImageView = UIImageView(image: #imageLiteral(resourceName: "currentStatusLabel"))
        titleImageView.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
        titleImageView.contentMode = .scaleAspectFit
        
        navigationItem.titleView = titleImageView
    }
    
    
    @objc func tick() {
        
        let date = Date()
        let format = "MMM-dd"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        
        let value = dateFormatter.string(from: date)
        
        timeLabel.text = DateFormatter.localizedString(from: Date(),
                                                       dateStyle: .none,
                                                       timeStyle: .short)
        dateLabel.text = value
        
    }
    
    //MARK: - Navigation Buttons (Info and Reload)
    
    @IBAction func reloadButtonTapped(_ sender: Any) {
        
        reloadButton.isEnabled = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            self.reloadButton.isEnabled = true
        }
        
        numberOfEntriesArray.removeAll()
        hourOfDay.removeAll()
        retrieveDataForDay(Day: determineDay())
     }
    
    @IBAction func infoButtonTapped(_ sender: Any) {
        
        // Prepare the popup assets
        let title = "Flux Version 1.0"
        let message = "This app currently calculates how busy the gym is based off gate statistics of Fall/Winter semesters 2017 - 2018. We are currently in the works of implementing live data. This app is not affiliated with the University of Calgary."
        
        // Create the dialog
        let popup = PopupDialog(title: title, message: message)
        
        // Create buttons
        let buttonOne = CancelButton(title: "EXIT") {
        }
        
        // Rate app button to be implemented after release
//        let buttonTwo = DefaultButton(title: "RATE THIS APP", dismissOnTap: false) {
//            print("What a beauty!")
//        }
        
        // Add buttons to dialog
        // Alternatively, you can use popup.addButton(buttonOne)
        // to add a single button
        //popup.addButtons([buttonOne, buttonTwo])
        popup.addButton(buttonOne)
        
        // Present dialog
        self.present(popup, animated: true, completion: nil)
    }
    
    //MARK: - Firebase Retrieval Functions
    
    func retrieveDataForDay(Day: String) {
        
        // Set the firebase reference
        ref = Database.database().reference().child("charts").child(Day)
        
        ref?.observeSingleEvent(of: .value, with: { (snapshot) in
            
            let groupKeys = snapshot.children.compactMap { $0 as? DataSnapshot }.map { $0.key }
            
            // This group will keep track of the number of blocks still pending
            let group = DispatchGroup()
            
            for child in snapshot.children {
                let snap = child as! DataSnapshot
                let key = snap.key
                let value = snap.value as! Double
                    
                self.numberOfEntriesArray.append(value)
                self.dayDictionary[key] = value
                    
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
                
                self.retrieveHoursOfDay(Day: self.determineDayForHours())

            }
        })
    }
    
    func retrieveHoursOfDay(Day: String) {
        
        // Set the firebase reference
        ref = Database.database().reference().child("charts").child("hoursForDay").child(Day)
        
        ref?.observeSingleEvent(of: .value, with: { (snapshot) in
            
            let groupKeys = snapshot.children.compactMap { $0 as? DataSnapshot }.map { $0.key }
            
            // This group will keep track of the number of blocks still pending
            let group = DispatchGroup()
            
            for child in snapshot.children {
                let snap = child as! DataSnapshot
                let value = snap.value as! String
                
                self.hourOfDay.append(value)
                
                //print("key = \(key) value = \(value)")
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
                
                self.retrieveValueToAdd(Day: self.determineDayForValueToAdd())
                
            }
        })
    }
    
    func retrieveValueToAdd(Day: String) {
        // Set the firebase reference
        ref = Database.database().reference().child("charts").child("valueToAdd").child(Day)
        
        ref?.observeSingleEvent(of: .value, with: { (snapshot) in
            
            let groupKeys = snapshot.children.compactMap { $0 as? DataSnapshot }.map { $0.key }
            
            // This group will keep track of the number of blocks still pending
            let group = DispatchGroup()
            
            let valueToAdd = snapshot.value as! Int
            
            for groupKey in groupKeys {
                group.enter()
                self.ref?.child("groups").child(groupKey).child("name").observeSingleEvent(of: .value, with: { snapshot in
                    group.leave()
                })
            }
            
            // We ask to be notified when every block left the group
            group.notify(queue: .main) {
                print("Works")
                self.lineChartProperties()
                self.lineChartView.setBarChartData(xValues: self.hourOfDay, yValues: self.numberOfEntriesArray, label: "Number of Entries")
                self.entriesOfCurrentHour(Day: self.determineDayForValueToAdd(), Value: valueToAdd)
                self.entriesOfNextHour(Day: self.determineDayForValueToAdd(), Value: valueToAdd)
                
                self.compareCurrentHourToNext(currentHour: self.getEntriesOfCurrentHour(Day: self.determineDayForValueToAdd(), Value: valueToAdd), nextHour: self.getEntriesOfNextHour(Day: self.determineDayForValueToAdd(), Value: valueToAdd))
                
                self.determineBusyLevel(Entries: self.getEntriesOfCurrentHour(Day: self.determineDayForValueToAdd(), Value: valueToAdd))

            }
        })

    }
    
    //MARK: - Entry Getter Functions
    
    func getCurrentHour() -> Int {
        let date = Date()
        let calendar = Calendar.current
        let hour = Int(calendar.component(.hour, from: date))
        
        return hour
    }
    
    func getEntriesOfCurrentHour(Day: String, Value: Int) -> Int {
        
        var returnValue = 0
        
        switch Day {
        case "M-F":
            if getCurrentHour() < hourOfDay.count + Value && getCurrentHour() >= Value {
                returnValue = Int(dayDictionary[String(getCurrentHour())]!)
                
            }
        case "SS":
            if getCurrentHour() < hourOfDay.count + Value && getCurrentHour() >= Value {
                returnValue = Int(dayDictionary[String(getCurrentHour())]!)
            }
            
        default:()
        }
        return returnValue
    }
    
    func getEntriesOfNextHour(Day: String, Value: Int) -> Int {
        
        var returnValue = 0
        
        switch Day {
        case "M-F":
            if getCurrentHour() + 1 < hourOfDay.count + Value && getCurrentHour() >= Value {
                returnValue = Int(dayDictionary[String(getCurrentHour() + 1)]!)
                
            }
        case "SS":
            if getCurrentHour() + 1 < hourOfDay.count + Value && getCurrentHour() >= Value {
                returnValue = Int(dayDictionary[String(getCurrentHour() + 1)]!)
            }
            
        default:()
        }
        
        return returnValue
    }
    
    //MARK: - Busy Status and Arrow Image Functions
    
    func determineBusyLevel(Entries: Int) {
        
        if Entries > 150 {
            busyStatusImage.isHidden = false
            busyStatusImage.image = #imageLiteral(resourceName: "busyStatus")
            busyStatusImage.popIn(fromScale: 1, duration: 4, delay: 1, completion: nil)
        }
        
        else if Entries < 150 && Entries > 100{
            busyStatusImage.isHidden = false
            busyStatusImage.image = #imageLiteral(resourceName: "moderatelyBusyStatus")
            busyStatusImage.popIn(fromScale: 1, duration: 4, delay: 1, completion: nil)

        }
        
        else if Entries > 0 && Entries < 100 {
            busyStatusImage.isHidden = false
            busyStatusImage.image = #imageLiteral(resourceName: "notBusyStatus")
            busyStatusImage.popIn(fromScale: 1, duration: 4, delay: 1, completion: nil)

        }
        
        else {
            busyStatusImage.isHidden = false
            busyStatusImage.image = #imageLiteral(resourceName: "closedStatus")
            busyStatusImage.popIn(fromScale: 1, duration: 4, delay: 1, completion: nil)
        }
        
    }
    
    func compareCurrentHourToNext(currentHour: Int, nextHour: Int) {

        if currentHour > nextHour {
            arrowImage.image = #imageLiteral(resourceName: "downRedArrow")
            arrowImage.shake(toward: .top, amount: 0.3, duration: 1, delay: 2, completion: nil)
        }
            
        else if currentHour < nextHour {
            arrowImage.image = #imageLiteral(resourceName: "upGreenArrow")
            arrowImage.shake(toward: .top, amount: 0.3, duration: 1, delay: 2, completion: nil)
        }

        else {
            arrowImage.isHidden = true
        }

    }
    
    //MARK: - Current and Next Hour Label Functions
    
    func entriesOfCurrentHour(Day: String, Value: Int) {
        
        switch Day {
        case "M-F":
            if getCurrentHour() < hourOfDay.count + Value && getCurrentHour() >= Value {
                currentEntriesLabel.text = String(Int(dayDictionary[String(getCurrentHour())]!))
            } else {
                currentEntriesLabel.text = "N/A"
            }
        case "SS":
            if getCurrentHour() < hourOfDay.count + Value && getCurrentHour() >= Value {
                currentEntriesLabel.text = String(Int(dayDictionary[String(getCurrentHour())]!))
            } else {
                currentEntriesLabel.text = "N/A"
            }
        
        default:
            currentEntriesLabel.text = "N/A"
        }
        
    }

    func entriesOfNextHour(Day: String, Value: Int) {
        
        switch Day {
        case "M-F":
            if getCurrentHour() + 1 < hourOfDay.count + Value && getCurrentHour() >= Value {
                nextHourEntriesLabel.text = String(Int(dayDictionary[String(getCurrentHour() + 1)]!))
            } else {
                nextHourEntriesLabel.text = "N/A"
            }
        case "SS":
            if getCurrentHour() + 1 < hourOfDay.count + Value && getCurrentHour() >= Value {
                nextHourEntriesLabel.text = String(Int(dayDictionary[String(getCurrentHour() + 1)]!))
            } else {
                nextHourEntriesLabel.text = "N/A"
            }
            
        default:
            nextHourEntriesLabel.text = "N/A"
        }
        
    }
    
    //MARK: - Determine Functions
    
    func determineDay() -> String {
        let date = Date()
        let calendar = Calendar.current
        let day = calendar.component(.weekday, from: date)
        var value = ""
        
        switch day {
        case 1:
            value = "sunday"
        case 2:
            value = "monday"
        case 3:
            value = "tuesday"
        case 4:
            value = "wednesday"
        case 5:
            value = "thursday"
        case 6:
            value = "friday"
        case 7:
            value = "saturday"
        default: ()
        }
    
        return value
    }
    
    func determineDayForHours() -> String {
        let date = Date()
        let calendar = Calendar.current
        let day = calendar.component(.weekday, from: date)
        var value = ""
        
        if day == 2 || day == 3 || day == 4 || day == 5 {
            value = "mondayToThursday"
        }
        
        else if day == 6 {
            value = "friday"
        }
        
        else {
            value = "saturdaySunday"
        }
        
        return value
    }
    
    func determineDayForValueToAdd() -> String {
        let date = Date()
        let calendar = Calendar.current
        let day = calendar.component(.weekday, from: date)
        var value = ""
        
        if day == 2 || day == 3 || day == 4 || day == 5 || day == 6{
            value = "M-F"
        }
            
        else {
            value = "SS"
        }
        
        return value
    }
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
        chartDataSet.setColor(#colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1))
        chartDataSet.mode = .cubicBezier
        chartDataSet.setDrawHighlightIndicators(false)

        
        self.data = chartData

    }
}





