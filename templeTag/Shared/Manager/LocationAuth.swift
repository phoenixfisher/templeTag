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

    override init() {
        super.init()
        manager.delegate = self
        updateStatus()
    }

    /// Call this from a button tap, not automatically on appear.
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

    private func updateStatus() {
        let current = manager.authorizationStatus
        status = current
        canShowUser = [.authorizedWhenInUse, .authorizedAlways].contains(current)
    }
}
