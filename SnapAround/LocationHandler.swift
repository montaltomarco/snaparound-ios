//
//  LocationHandler.swift
//  SnapAround
//
//  Created by Mehdi Kitane on 05/05/2015.
//  Copyright (c) 2015 Mehdi Kitane. All rights reserved.
//

import Foundation
import CoreLocation

protocol LocationHandlerDelegate {
    func didUpdateLocation()
}

class LocationHandler : NSObject, CLLocationManagerDelegate {
    
    var locationManager : CLLocationManager!
    var delegate : LocationHandlerDelegate?
    
    func startLocationTracker() {
        self.locationManager = CLLocationManager()
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.delegate = self
        
        if #available(iOS 8.0, *) {
            self.locationManager.requestWhenInUseAuthorization()
        } else {
            // Fallback on earlier versions
        }
        self.locationManager.startUpdatingLocation()
    }
    
    func stopLocationTracker() {
        self.locationManager.stopUpdatingLocation()
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        
    }
    
    func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation) {
        NSUserDefaults.standardUserDefaults().setObject(newLocation.coordinate.latitude, forKey: "SnapLatitude")
        NSUserDefaults.standardUserDefaults().setObject(newLocation.coordinate.longitude, forKey: "SnapLongitude")
        stopLocationTracker()
        
        self.delegate?.didUpdateLocation()
    }
    
}