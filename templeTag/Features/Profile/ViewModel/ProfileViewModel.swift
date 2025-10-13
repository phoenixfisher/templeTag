//
//  ProfileViewModel.swift
//  templeTag
//
//  Created by Phoenix Fisher on 10/13/25.
//

import SwiftUI
import Combine

// MARK: - ViewModel + Models (no mock data)
final class ProfileViewModel: ObservableObject {
    // Display
    @Published var displayName: String = ""
    @Published var initialsPlaceholder: String = "TT"
    @Published var avatar: Image? = nil
    @Published var homeTemple: String = ""
    @Published var memberSince: Date? = nil
    
    // Stats
    @Published var totalVisited: Int = 0
    @Published var totalTemples: Int = 0
    @Published var countriesVisited: Int = 0
    
    // Activity
    @Published var lastVisit: Visit? = nil
    @Published var upcomingVisit: Visit? = nil
    @Published var recentVisits: [Visit] = []
    
    // Achievements
    @Published var badges: [Badge] = []
    
    // Settings
    @Published var notificationsEnabled: Bool = false
    @Published var defaultView: DefaultView = .map
    
    // Goal
    @Published var currentGoal: Goal = .init(label: "Set a goal", current: 0, target: 0)
    
    // Handlers (wire these to flows/sheets)
    var onEditProfile: (() -> Void)?
    var onToggleNotifications: (() -> Void)?
    var onChangeDefaultView: (() -> Void)?
    var onExport: (() -> Void)?
    var onPrivacy: (() -> Void)?
    
    // Derived
    var progressFraction: CGFloat {
        guard totalTemples > 0 else { return 0 }
        return CGFloat(min(1.0, max(0.0, Double(totalVisited) / Double(totalTemples))))
    }
}
