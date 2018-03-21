//
//  MainVC.swift
//  flux
//
//  Created by VICTOR CHU on 2018-03-19.
//  Copyright © 2018 Victor Chu. All rights reserved.
//

import UIKit

class HomeVC: UIViewController {

    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var statusDescriptionLabel: UILabel!
    @IBOutlet weak var statusImage: UIImageView!
    @IBOutlet var backgroundView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addNavigationBarTitleImage()
        determineGymStatus()
    }
    @IBAction func reloadButtonTapped(_ sender: Any) {
        self.determineGymStatus()
    }
    
    func addNavigationBarTitleImage() {
        let titleImageView = UIImageView(image: #imageLiteral(resourceName: "FluxNavBarIcon"))
        titleImageView.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
        titleImageView.contentMode = .scaleAspectFit
        
        navigationItem.titleView = titleImageView
    }
    
    func lowStatus() {
        statusImage.image = #imageLiteral(resourceName: "CardioMachineIcon")
        backgroundView.backgroundColor = #colorLiteral(red: 0.2980392157, green: 0.6862745098, blue: 0.3098039216, alpha: 1)
        statusLabel.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        statusDescriptionLabel.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        statusLabel.text = "Low"
        statusDescriptionLabel.text = "Currently the gym is not busy."
    }
    
    func mediumStatus() {
        statusImage.image = #imageLiteral(resourceName: "FlyMachineIcon")
        backgroundView.backgroundColor = #colorLiteral(red: 1, green: 0.5960784314, blue: 0, alpha: 1)
        statusLabel.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        statusDescriptionLabel.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        statusLabel.text = "Medium"
        statusDescriptionLabel.text = "Currently the gym moderately busy."
    }
    
    func highStatus() {
        statusImage.image = #imageLiteral(resourceName: "100kgPlateIcon")
        backgroundView.backgroundColor = #colorLiteral(red: 0.9568627451, green: 0.262745098, blue: 0.2156862745, alpha: 1)
        statusLabel.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        statusDescriptionLabel.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        statusLabel.text = "High"
        statusDescriptionLabel.text = "Currently the gym is busy."
    }
    
    
    func determineGymStatus() {
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let day = calendar.component(.weekday, from: date)
        
        if hour == 21 && day == 3 {
          highStatus()
        }
    }



}
