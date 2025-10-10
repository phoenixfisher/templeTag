//
//  TemplesViewModel.swift
//  templeTag
//
//  Created by Phoenix Fisher on 10/9/25.
//

import SwiftUI
import Combine

final class TemplesViewModel: ObservableObject {
    @Published var temples: [Temple] = []
    @Published var selectedTemple: Temple? = nil
    @Published var isLoading = false
    @Published var error: String?

    private let client = TempleClient()

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
