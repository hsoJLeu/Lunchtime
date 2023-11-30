//
//  LocationClient.swift
//  LunchTime
//
//  Created by Josh Leung on 11/17/23.
//

import Foundation
import CoreLocation

class LocationClient: NSObject, ObservableObject, CLLocationManagerDelegate {
    static let shared = LocationClient()

    private let manager: CLLocationManager = .init()
    @Published var location: CLLocation?
    
    private var locationDoesExist: Bool {
        return location != nil
    }

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

    func locationExists() -> Bool {
        return locationDoesExist
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        debugPrint("locations: \(locations)")
        guard !locations.isEmpty else { return }
        self.location = locations.last
        self.manager.stopUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to update users location with error: \(error)")
    }
}
