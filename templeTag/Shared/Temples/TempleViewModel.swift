//
//  TemplesViewModel.swift
//  templeTag
//
//  Created by Phoenix Fisher on 10/9/25.
//

import SwiftUI
import Combine
import CoreLocation

final class TempleViewModel: ObservableObject {
    @Published var temples: [Temple] = []
    @Published var selectedTemple: Temple? = nil
    @Published var isLoading = false
    @Published var error: String?

    private let client = TempleClient()
    
    // For filtering when showing on maps
    var templesWithCoords: [(temple: Temple, coordinate: CLLocationCoordinate2D)] {
        temples.compactMap { temple in
            guard let coord = temple.coordinate else { return nil }
            return (temple, coord)
        }
    }

    @MainActor
    func load() async {
        if isLoading { return }
        isLoading = true
        defer { isLoading = false }
        do {
            let items = try await client.fetchTemples()
            self.temples = items
        } catch {
            self.error = error.localizedDescription
        }
    }
}
