//
//  ProfileView.swift
//  templeTag
//
//  Created by Phoenix Fisher on 10/9/25.
//

import SwiftUI
import CoreGraphics

struct ProfileView: View {
    @StateObject private var vm: ProfileViewModel
    
    init(vm: ProfileViewModel) {
        _vm = StateObject(wrappedValue: vm)
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                header
                stats
                progress
                achievements
                recentActivity
                settings
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 24)
        }
        .background(.background)
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    // MARK: Components making up body view
    
    // Header
    private var header: some View {
        HStack(alignment: .center, spacing: 16) {
            Avatar(initials: vm.initialsPlaceholder, image: vm.avatar)
                .frame(width: 72, height: 72)
            
            VStack(alignment: .leading, spacing: 6) {
                Text(vm.displayName.isEmpty ? "Your Name" : vm.displayName)
                    .font(.title2.weight(.semibold))
                Label(vm.homeTemple.isEmpty ? "Home Temple" : vm.homeTemple, systemImage: "house.fill")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                if let memberSince = vm.memberSince {
                    Text("Member since \(memberSince.formatted(.dateTime.year().month()))")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
            }
            Spacer()
            Button { vm.onEditProfile?() } label: {
                Image(systemName: "pencil")
                    .font(.title3.weight(.semibold))
                    .padding(10)
                    .background(.thinMaterial, in: Circle())
            }
            .accessibilityLabel("Edit profile")
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(.ultraThinMaterial)
                .shadow(radius: 4, y: 2)
        )
    }
    
    // Stats
    private var stats: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(title: "Overview")
            LazyVGrid(columns: [GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12)], spacing: 12) {
                StatCard(title: "Temples Visited",
                         value: "\(vm.totalVisited)",
                         subtitle: "of \(vm.totalTemples)")
                StatCard(title: "Countries",
                         value: "\(vm.countriesVisited)",
                         subtitle: "visited")
                StatCard(title: "Last Visit",
                         value: vm.lastVisit?.templeName ?? "—",
                         subtitle: vm.lastVisit.map { $0.date.formatted(date: .abbreviated, time: .omitted) } ?? "")
                StatCard(title: "Upcoming",
                         value: vm.upcomingVisit?.templeName ?? "—",
                         subtitle: vm.upcomingVisit.map { $0.date.formatted(date: .abbreviated, time: .omitted) } ?? "")
            }
        }
    }
    
    // Progress
    private var progress: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(title: "Progress")
            HStack(spacing: 16) {
                ProgressRing(progress: vm.progressFraction)
                    .frame(width: 88, height: 88)
                VStack(alignment: .leading, spacing: 6) {
                    Text("\(Int(vm.progressFraction * 100))% complete")
                        .font(.headline)
                    Text("You’ve checked off \(vm.totalVisited) of \(vm.totalTemples) temples.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    HStack(spacing: 8) {
                        TagChip(text: "Goal: \(vm.currentGoal.label)")
                        TagChip(text: vm.currentGoal.progressString)
                    }
                }
                Spacer()
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 24)
                    .fill(.ultraThinMaterial)
                    .shadow(radius: 4, y: 2)
            )
        }
    }
    
    // Achievements
    private var achievements: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(title: "Achievements")
            if vm.badges.isEmpty {
                EmptyState(text: "No badges yet. Start visiting to earn your first one!")
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(vm.badges) { badge in
                            BadgeCard(badge: badge)
                        }
                    }
                    .padding(.vertical, 4)
                }
            }
        }
    }
    
    // Recent Activity
    private var recentActivity: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(title: "Recent Activity")
            if vm.recentVisits.isEmpty {
                EmptyState(text: "No recent visits recorded.")
            } else {
                VStack(spacing: 8) {
                    ForEach(vm.recentVisits) { visit in
                        HStack(alignment: .top, spacing: 12) {
                            Image(systemName: "building.columns.fill")
                                .font(.title3)
                                .padding(10)
                                .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 12))
                            VStack(alignment: .leading, spacing: 2) {
                                Text(visit.templeName)
                                    .font(.subheadline.weight(.semibold))
                                Text(visit.date.formatted(date: .abbreviated, time: .omitted))
                                    .font(.footnote)
                                    .foregroundStyle(.secondary)
                                if let note = visit.note, !note.isEmpty {
                                    Text(note)
                                        .font(.footnote)
                                        .foregroundStyle(.secondary)
                                        .lineLimit(2)
                                }
                            }
                            Spacer()
                        }
                        .padding(12)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(.ultraThinMaterial)
                        )
                    }
                }
            }
        }
    }
    
    // Settings
    private var settings: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(title: "Settings")
            VStack(spacing: 8) {
                SettingRow(icon: "bell.badge", title: "Notifications", detail: vm.notificationsEnabled ? "On" : "Off") {
                    vm.onToggleNotifications?()
                }
                SettingRow(icon: "map", title: "Default View", detail: vm.defaultView.rawValue) {
                    vm.onChangeDefaultView?()
                }
                SettingRow(icon: "square.and.arrow.up", title: "Export Data", detail: "CSV") {
                    vm.onExport?()
                }
                SettingRow(icon: "lock", title: "Privacy", detail: "Manage") {
                    vm.onPrivacy?()
                }
            }
            .padding(12)
            .background(
                RoundedRectangle(cornerRadius: 24)
                    .fill(.ultraThinMaterial)
                    .shadow(radius: 4, y: 2)
            )
        }
        .padding(.bottom, 24)
    }
}

#Preview {
    ProfileView(vm: ProfileViewModel())
        .tint(.primary)
        .background(Color(.systemGroupedBackground))
}
