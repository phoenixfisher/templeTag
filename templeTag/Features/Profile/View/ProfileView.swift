//
//  ProfileView.swift
//  templeTag
//
//  Created by Phoenix Fisher on 10/9/25.
//

import SwiftUI
import CoreGraphics

// MARK: - ProfileView
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
    
    // MARK: Header
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
    
    // MARK: Stats
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
    
    // MARK: Progress
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
    
    // MARK: Achievements
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
    
    // MARK: Recent Activity
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
    
    // MARK: Settings
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

// MARK: - Components

private struct SectionHeader: View {
    var title: String
    var actionTitle: String? = nil
    var action: (() -> Void)? = nil
    
    var body: some View {
        HStack {
            Text(title)
                .font(.headline)
            Spacer()
            if let actionTitle, let action {
                Button(actionTitle, action: action)
                    .font(.subheadline.weight(.semibold))
            }
        }
        .padding(.horizontal, 4)
    }
}

private struct EmptyState: View {
    var text: String
    var body: some View {
        Text(text)
            .font(.subheadline)
            .foregroundStyle(.secondary)
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(.vertical, 24)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .strokeBorder(.quaternary, lineWidth: 1)
            )
    }
}

private struct Avatar: View {
    var initials: String
    var image: Image?
    
    var body: some View {
        ZStack {
            if let image {
                image
                    .resizable()
                    .scaledToFill()
            } else {
                Text(initials)
                    .font(.title2.weight(.bold))
                    .foregroundStyle(.primary)
                    .minimumScaleFactor(0.6)
                    .padding(8)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(
                        LinearGradient(colors: [.teal.opacity(0.25), .blue.opacity(0.25)],
                                       startPoint: .topLeading, endPoint: .bottomTrailing)
                    )
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 18))
        .overlay(
            RoundedRectangle(cornerRadius: 18).strokeBorder(.quaternary, lineWidth: 1)
        )
        .shadow(radius: 3, y: 1)
    }
}

private struct StatCard: View {
    var title: String
    var value: String
    var subtitle: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.footnote)
                .foregroundStyle(.secondary)
            Text(value)
                .font(.title3.weight(.semibold))
            if !subtitle.isEmpty {
                Text(subtitle)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(.ultraThinMaterial)
                .shadow(radius: 2, y: 1)
        )
    }
}

private struct TagChip: View {
    var text: String
    var body: some View {
        Text(text)
            .font(.caption.weight(.medium))
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(.thinMaterial, in: Capsule())
    }
}

private struct ProgressRing: View {
    var progress: CGFloat // 0...1
    var body: some View {
        ZStack {
            Circle()
                .trim(from: 0, to: 1)
                .stroke(.quaternary, style: StrokeStyle(lineWidth: 10, lineCap: .round))
                .rotationEffect(.degrees(-90))
            Circle()
                .trim(from: 0, to: max(0.001, progress))
                .stroke(.primary.opacity(0.9), style: StrokeStyle(lineWidth: 10, lineCap: .round))
                .rotationEffect(.degrees(-90))
                .animation(.smooth(duration: 0.6), value: progress)
            Text("\(Int(progress * 100))%")
                .font(.headline)
        }
        .padding(6)
        .background(RoundedRectangle(cornerRadius: 20).fill(.ultraThinMaterial))
    }
}

private struct BadgeCard: View {
    let badge: Badge
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: badge.icon)
                .font(.title2)
                .padding(12)
                .background(.thinMaterial, in: Circle())
            Text(badge.title)
                .font(.footnote.weight(.semibold))
                .multilineTextAlignment(.center)
            Text(badge.subtitle)
                .font(.caption)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(width: 140)
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(.ultraThinMaterial)
                .shadow(radius: 3, y: 2)
        )
    }
}

private struct SettingRow: View {
    var icon: String
    var title: String
    var detail: String?
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.body.weight(.semibold))
                    .frame(width: 28, height: 28)
                    .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 8))
                Text(title)
                    .font(.body)
                Spacer()
                if let detail {
                    Text(detail)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                Image(systemName: "chevron.right")
                    .font(.footnote.weight(.semibold))
                    .foregroundStyle(.tertiary)
            }
            .padding(12)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Preview (uses empty VM; not "mock data", just to render)
#Preview {
    NavigationStack {
        ProfileView(vm: ProfileViewModel())
            .tint(.primary)
            .background(Color(.systemGroupedBackground))
    }
}
