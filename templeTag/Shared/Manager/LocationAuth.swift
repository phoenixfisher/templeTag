//
//  LocationAuth.swift
//  templeTag
//
//  Created by Phoenix Fisher on 10/9/25.
//

import CoreLocation
import SwiftUI
import Combine

@MainActor
final class LocationAuth: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()
    
    @Published var status: CLAuthorizationStatus = .notDetermined
    @Published var canShowUser = false
    @Published var location: CLLocationCoordinate2D?

    override init() {
        super.init()
        manager.delegate = self
        updateStatus()
    }

    func requestAuthorization() {
        guard CLLocationManager.locationServicesEnabled() else { return }
        if manager.authorizationStatus == .notDetermined {
            manager.requestWhenInUseAuthorization()
        } else {
            updateStatus()
        }
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        updateStatus()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let latest = locations.last else { return }
        location = latest.coordinate
    }

    private func updateStatus() {
        let current = manager.authorizationStatus
        status = current
        canShowUser = [.authorizedWhenInUse, .authorizedAlways].contains(current)
        
        if canShowUser {
            manager.startUpdatingLocation()
        } else {
            manager.stopUpdatingLocation()
        }
    }
}
