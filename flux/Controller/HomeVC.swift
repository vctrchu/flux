//
//  MainVC.swift
//  flux
//
//  Created by VICTOR CHU on 2018-03-19.
//  Copyright © 2018 Victor Chu. All rights reserved.
//

import UIKit

class HomeVC: UIViewController {

    @IBOutlet weak var statusLabel: UIImageView!
    @IBOutlet weak var statusDescriptionLabel: UILabel!
    @IBOutlet weak var statusImage: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var dayPickerView: UIPickerView!
    @IBOutlet weak var hourPickerView: UIPickerView!
    @IBOutlet weak var amPmPickerView: UIPickerView!
    
    
    let refreshControl = UIRefreshControl()
    var dayArray = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
    var hourArray = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12"]
    var ampmArray = ["AM", "PM"]
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshControl.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
        scrollView.addSubview(refreshControl)
        addNavigationBarTitleImage()
        dayPickerView.delegate = self
        hourPickerView.delegate = self
        amPmPickerView.delegate = self
        dayPickerView.dataSource = self
        hourPickerView.dataSource = self
        amPmPickerView.dataSource = self
        hidePickerViews()

    }
    
    @objc func didPullToRefresh() {
        determineGymStatus()
        hidePickerViews()
        refreshControl.endRefreshing()
    }
    
    func determineGymStatus() {
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let day = calendar.component(.weekday, from: date)
        
        if hour == 13 && day == 5 {
            highStatus()
        }
    }
    
    func hidePickerViews() {
        dayPickerView.isHidden = true
        hourPickerView.isHidden = true
        amPmPickerView.isHidden = true
    }
    
    func showPickerViews() {
        dayPickerView.isHidden = false
        hourPickerView.isHidden = false
        amPmPickerView.isHidden = false
    }

    
    func addNavigationBarTitleImage() {
        let titleImageView = UIImageView(image: #imageLiteral(resourceName: "FluxNavBarIcon"))
        titleImageView.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
        titleImageView.contentMode = .scaleAspectFit
        
        navigationItem.titleView = titleImageView
    }
    
    func lowStatus() {
        statusImage.image = #imageLiteral(resourceName: "NotBusyBar")
        statusDescriptionLabel.text = "Currently the gym is not busy."
    }

    func moderateStatus() {
        statusImage.image = #imageLiteral(resourceName: "ModerateBusyBar")
        statusDescriptionLabel.text = "Currently the gym moderately busy."
    }

    func highStatus() {
        statusImage.image = #imageLiteral(resourceName: "HighBusyBar")
        statusDescriptionLabel.text = "Currently the gym is busy."
    }


    @IBAction func customTimeButtonTapped(_ sender: Any) {
        if dayPickerView.isHidden, hourPickerView.isHidden, amPmPickerView.isHidden {
            showPickerViews()
        }
    }
    
}


extension HomeVC: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == dayPickerView {
            return dayArray.count
        } else if pickerView == hourPickerView {
            return hourArray.count
        } else {
            return ampmArray.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == dayPickerView {
            return dayArray[row]
        } else if pickerView == hourPickerView {
            return hourArray[row]
        } else {
            return ampmArray[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {

    }
    
    
}


