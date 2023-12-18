//
//  Location.swift
//  Alura Ponto
//
//  Created by Yuri Cunha on 18/12/23.
//

import UIKit
import CoreLocation

protocol LocationDelegate: AnyObject {
    func updateUserLocation(latitude: Double?, longitude: Double?)
}

final class Location: NSObject {
    
    weak var delegate: LocationDelegate?
    
    private var latitude: CLLocationDegrees?
    private var longitude: CLLocationDegrees?
    func permition(_ locationManager: CLLocationManager) {
        locationManager.delegate = self
        
        switch locationManager.authorizationStatus {
            
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            break
        case .denied:
            break
        case .authorizedAlways, .authorizedWhenInUse:
            break
        @unknown default:
            fatalError()
        }
    }
        
}


extension Location: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            manager.startUpdatingLocation()
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            latitude = location.coordinate.latitude
            longitude = location.coordinate.longitude
            delegate?.updateUserLocation(latitude: latitude, longitude: longitude)
        }
    }
}
