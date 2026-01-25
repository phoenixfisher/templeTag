//
//  ProfileViewModel.swift
//  templeTag
//
//  Created by Phoenix Fisher on 10/13/25.
//

import SwiftUI
import Combine

@MainActor
final class ProfileViewModel: ObservableObject {
    // Display
    @Published var userId: String = ""
    @Published var avatarImage: UIImage? = nil
    @Published var displayName: String = ""
    @Published var initials: String = "??"
    @Published var avatar: Image? = nil
    @Published var homeTemple: String = "Provo City Center Temple"
    @Published var memberSince: Date? = nil
    @Published var isLoading: Bool = false
    
    // Stats
    @Published var totalVisited: Int = 30
    @Published var totalTemples: Int = 43
    @Published var countriesVisited: Int = 3
    @Published var currentStreak: Int = 6
    
    // Activity
    @Published var lastVisit: Visit? = Visit(templeName: "Pason Temple", date: Date() - 1000000, note: "Fun")
    @Published var upcomingVisit: Visit? = Visit(templeName: "Pason Temple", date: Date() + 600000, note: "Fun")
    @Published var recentVisits: [Visit] = [
        Visit(templeName: "Pason Temple", date: Date() - 1000000, note: "Fun"),
        Visit(templeName: "Las Vegas Temple", date: Date() - 5000000, note: "Fun"),
        Visit(templeName: "Mesa Temple", date: Date() - 9000000, note: "Fun")
    ]
    
    // Achievements
    @Published var badges: [Badge] = [
        Badge(title: "Early Riser", subtitle: "Checked in before 7 AM", icon: "sunrise.fill"),
        Badge(title: "Streak Keeper", subtitle: "7 days in a row", icon: "flame.fill"),
        Badge(title: "Community Helper", subtitle: "Assisted 3 members", icon: "hands.sparkles.fill"),
        Badge(title: "Pilgrim", subtitle: "Visited 5 temples", icon: "figure.walk"),
        Badge(title: "Mindful Moment", subtitle: "Meditated for 20 minutes", icon: "brain.head.profile")
    ]
    
    // Settings
    @Published var notificationsEnabled: Bool = false
    
    // Goal
    @Published var currentGoal: Goal = .init(label: "Visit 26 temples this year", current: 11, target: 26)
    
    // Editor
    @Published var isEditing: Bool = false
    
    // Handlers
    var onToggleNotifications: (() -> Void)?
    var onChangeDefaultView: (() -> Void)?
    var onExport: (() -> Void)?
    var onPrivacy: (() -> Void)?
    var onChangePhoto: (() -> Void)?
    
    // Derived
    var progressFraction: CGFloat {
        guard currentGoal.target > 0 else { return 0 }
        return CGFloat(min(1.0, max(0.0, Double(currentGoal.current) / Double(currentGoal.target))))
    }
    
    func saveProfile() -> Bool {
        return true
    }
    
    func deleteProfile() -> Bool {
        return true
    }
}
