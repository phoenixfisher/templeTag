//
//  ProfileViewModel.swift
//  templeTag
//
//  Created by Phoenix Fisher on 10/13/25.
//

import SwiftUI
import Combine

final class ProfileViewModel: ObservableObject {
    // Display
    @Published var userId: String = ""
    @Published var avatarImage: UIImage? = nil
    @Published var displayName: String = ""
    @Published var initials: String = "??"
    @Published var avatar: Image? = nil
    @Published var homeTemple: String = ""
    @Published var memberSince: Date? = nil
    @Published var isLoading: Bool = false
    
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
    
    // Editor
    @Published var isEditing: Bool = false
    @Published var editDraft: ProfileDraft = .init()
    
    // Handlers
    var onEditProfile: (() -> Void)?
    var onToggleNotifications: (() -> Void)?
    var onChangeDefaultView: (() -> Void)?
    var onExport: (() -> Void)?
    var onPrivacy: (() -> Void)?
    var onSignIn: (() -> Void)?
    var onSignOut: (() -> Void)?
    
    // Derived
    var progressFraction: CGFloat {
        guard totalTemples > 0 else { return 0 }
        return CGFloat(min(1.0, max(0.0, Double(totalVisited) / Double(totalTemples))))
    }
    
    init() {
        // Wire up the edit button handler by default
        self.onEditProfile = { [weak self] in
            self?.beginEditing()
        }
    }
    
    // MARK: - Editing
    func beginEditing() {
        // Seed the draft from current values
        editDraft = ProfileDraft(
            displayName: displayName,
            homeTemple: homeTemple
        )
        isEditing = true
    }

    func applyDraft() {
        // Update image
        if let data = try? LocalAvatarStore.shared.loadAvatarJPEG(userId: userId), let img = UIImage(data: data) {
            avatarImage = img
        }
        // Update name
        let trimmedName = editDraft.displayName.trimmingCharacters(in: .whitespacesAndNewlines)
        if !trimmedName.isEmpty {
            displayName = trimmedName
            // Update initials from displayName (first letters of up to two words)
            let parts = trimmedName.split(separator: " ")
            let first = parts.first?.first.map(String.init) ?? ""
            let second = parts.dropFirst().first?.first.map(String.init) ?? ""
            let candidate = (first + second).uppercased()
            initials = candidate.isEmpty ? "??" : candidate
        }
        // Update home temple
        homeTemple = editDraft.homeTemple.trimmingCharacters(in: .whitespacesAndNewlines)
        isEditing = false
        // TODO: Persist changes to storage if applicable
    }
}
