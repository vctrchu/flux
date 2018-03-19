//
//  LocationService.swift
//  flux
//
//  Created by VICTOR CHU on 2018-03-19.
//  Copyright © 2018 Victor Chu. All rights reserved.
//

import UIKit
import CoreLocation

class LocationService: NSObject, CLLocationManagerDelegate  {
    static let instance = LocationService()
    let locationManager = CLLocationManager()
    
    func enableLocationServices() {
        locationManager.delegate = self
        
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            // Request when-in-use authorization
            locationManager.requestAlwaysAuthorization()
            break
            
        case .restricted, .denied:
            print("Location service is currently denied.")
            break
            
        case .authorizedWhenInUse:
            print("Location services only used when app is open.")
            
        case .authorizedAlways:
            print("Location services is always in use.")
        }
    }
    
    func escalateLocationServiceAuthorization() {
        // Escalate only when the authroization is set to when in use.
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            locationManager.requestAlwaysAuthorization()
        } else if CLLocationManager.authorizationStatus() == .restricted {
            locationManager.requestAlwaysAuthorization()
        } else if CLLocationManager.authorizationStatus() == .denied {
            locationManager.requestAlwaysAuthorization()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted, .denied:
            // Disable your app's location features
            print("Disabling app features that use location services.")
            break
            
        case .authorizedWhenInUse:
            // Enable only your app's when in use features.
            print("When in use: No features work unless location services is always on.")
            break
            
        case .authorizedAlways:
            // Enable any of your app's location services.
            print("Enable app features that use location services.")
            break
            
        case .notDetermined:
            break
        }
    }
    
    
    
    
}
