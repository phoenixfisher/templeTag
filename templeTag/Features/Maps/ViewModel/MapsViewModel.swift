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
    private var nearestSearchWorkItem: DispatchWorkItem?
    private let templeVM: TempleViewModel

    init(templeVM: TempleViewModel) { self.templeVM = templeVM }

    func getNearestTemple(from location: CLLocationCoordinate2D) {
        guard !templeVM.temples.isEmpty else { return }
        nearestTemple = templeVM.temples.min { a, b in
            distance(from: location, to: a.coordinate) < distance(from: location, to: b.coordinate)
        }
        
        // Successfully fetched nearest temple
        nearestSearchWorkItem?.cancel()
        isSearchingNearest = false
        nearestSearchFailed = false
    }

    func startNearestSearch(currentLocation: CLLocationCoordinate2D?) {
        // Cancel previous items and start search
        nearestSearchWorkItem?.cancel()
        nearestSearchFailed = false
        isSearchingNearest = true
        
        if let loc = currentLocation {
            getNearestTemple(from: loc)
        }
        
        let work = DispatchWorkItem { [weak self] in
            guard let self else { return }
            // If the search fails
            if self.nearestTemple == nil {
                self.nearestSearchFailed = true
            }
            self.isSearchingNearest = false
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5, execute: work)
    }
    
    private func distance(from a: CLLocationCoordinate2D, to b: CLLocationCoordinate2D) -> CLLocationDistance {
        CLLocation(latitude: a.latitude, longitude: a.longitude)
            .distance(from: CLLocation(latitude: b.latitude, longitude: b.longitude))
    }
}
