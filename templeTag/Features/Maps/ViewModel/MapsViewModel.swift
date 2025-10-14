//
//  MapsViewModel.swift
//  templeTag
//
//  Created by Phoenix Fisher on 10/10/25.
//

import SwiftUI
import CoreLocation
import Combine

@MainActor
final class MapsViewModel: ObservableObject {
    @Published var nearestTemple: Temple? = nil
    @Published var isSearchingNearest: Bool = false
    @Published var nearestSearchFailed: Bool = false
    @Published var cachedLocation: CLLocationCoordinate2D?

    private let autoRecomputeInterval: TimeInterval = 60 // seconds
    private var lastSearchAt: Date?
    private var searchStartAt: Date?
    private var debounceWorkItem: DispatchWorkItem?
    private var nearestSearchWorkItem: DispatchWorkItem?
    private let templeVM: TempleViewModel

    init(templeVM: TempleViewModel) { self.templeVM = templeVM }

    func getNearestTemple(from location: CLLocationCoordinate2D) {
        guard !templeVM.temples.isEmpty else { return }
        nearestTemple = templeVM.temples.min { a, b in
            distance(from: location, to: a.coordinate) < distance(from: location, to: b.coordinate)
        }
        print("Nearest temple found: \(nearestTemple?.name ?? "")")
        
        // Successfully fetched nearest temple
        nearestSearchWorkItem?.cancel()
        isSearchingNearest = false
        nearestSearchFailed = false
        lastSearchAt = Date()
        searchStartAt = nil
    }

    func startNearestSearch(currentLocation: CLLocationCoordinate2D?) {
        // Use explicit location or fallback to cached
        let loc = currentLocation ?? cachedLocation

        // Cancel any pending debounce
        debounceWorkItem?.cancel()
        nearestSearchWorkItem?.cancel()
        nearestSearchFailed = false
        isSearchingNearest = true
        
        guard let loc else {
            print("No location available.")
            isSearchingNearest = false
            nearestSearchFailed = true
            return
        }

        guard !templeVM.temples.isEmpty else {
            print("No temple data loaded.")
            isSearchingNearest = false
            nearestSearchFailed = true
            return
        }

        // Search starting with location
        print("Searching for nearest temple using current location...")
        searchStartAt = Date()
        getNearestTemple(from: loc)

        // 5s timeout
        let work = DispatchWorkItem { [weak self] in
            guard let self else { return }
            if self.nearestTemple == nil {
                print("Search timed out (no temple found in 5 seconds).")
                self.nearestSearchFailed = true
            }
            self.isSearchingNearest = false
        }
        nearestSearchWorkItem = work
        DispatchQueue.main.asyncAfter(deadline: .now() + 5, execute: work)
    }

    func considerLocationUpdate(_ newLocation: CLLocationCoordinate2D) {
        cachedLocation = newLocation

        // If a search is already in progress, don't restart it on every tick
        if isSearchingNearest { return }
        if let last = lastSearchAt, Date().timeIntervalSince(last) < autoRecomputeInterval {
            return
        }

        // Debounce rapid incoming location updates: wait 1s of calm before starting
        debounceWorkItem?.cancel()
        let work = DispatchWorkItem { [weak self] in
            self?.startNearestSearch(currentLocation: newLocation)
        }
        debounceWorkItem = work
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: work)
    }
    
    private func distance(from a: CLLocationCoordinate2D, to b: CLLocationCoordinate2D) -> CLLocationDistance {
        CLLocation(latitude: a.latitude, longitude: a.longitude)
            .distance(from: CLLocation(latitude: b.latitude, longitude: b.longitude))
    }
}
