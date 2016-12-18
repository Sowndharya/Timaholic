//
//  TrackLocation.swift
//  Discover
//
//  Created by Rizwan Ahmed on 07/12/16.
//  Copyright © 2016 Sowndharya. All rights reserved.
//


import MapKit

protocol LocationUpdateProtocol {
    func locationDidUpdateToLocation(location : CLLocationCoordinate2D)
}


class UserLocationManager: NSObject, CLLocationManagerDelegate {
    
    var locationManager = CLLocationManager()
    
    var delegate : LocationUpdateProtocol!
    
    func getLocation () {
        
        if CLLocationManager.locationServicesEnabled() {
        
            print("initializing UserLocationManager")
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.requestLocation()
        }
    }
    
    // MARK: - CLLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        
        self.delegate.locationDidUpdateToLocation(location: locValue)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        Utilities.showAlertActionDefault(self, "Location Error", error.localizedDescription)
    }
    
}

