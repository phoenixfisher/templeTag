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
    private let templeVM: TempleViewModel

    init(templeVM: TempleViewModel) { self.templeVM = templeVM }

    func getNearestTemple(from location: CLLocationCoordinate2D) {
        guard !templeVM.temples.isEmpty else { return }
        nearestTemple = templeVM.temples.min { a, b in
            distance(from: location, to: a.coordinate) < distance(from: location, to: b.coordinate)
        }
    }

    private func distance(from a: CLLocationCoordinate2D, to b: CLLocationCoordinate2D) -> CLLocationDistance {
        CLLocation(latitude: a.latitude, longitude: a.longitude)
            .distance(from: CLLocation(latitude: b.latitude, longitude: b.longitude))
    }
}
