//
//  LocationClient.swift
//  LunchTime
//
//  Created by Josh Leung on 11/17/23.
//

import Foundation
import CoreLocation

class LocationClient: NSObject, CLLocationManagerDelegate {
    static let shared = LocationClient()

    private let manager: CLLocationManager = .init()
    var location: CLLocation?

    private override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }

    func requestUserLocation() {
        if manager.authorizationStatus == .authorizedWhenInUse {
            manager.requestLocation()
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        debugPrint("locations: \(locations)")
        self.location = locations.last
        self.manager.stopUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        debugPrint("Failed to update users location with error: \(error)")
    }
}
