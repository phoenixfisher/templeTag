//
//  ProfileView.swift
//  templeTag
//
//  Created by Phoenix Fisher on 10/9/25.
//

import SwiftUI
import CoreGraphics
import FirebaseAuth

struct ProfileView: View {
    @EnvironmentObject var authVM: AuthViewModel
    @EnvironmentObject var authRouter: AuthRouter
    @StateObject private var vm = ProfileViewModel()
    
    private func showAuthSheet() {
        withAnimation(.easeInOut) {
            authRouter.showAuthSheet = true
        }
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    account
                    stats
                    progress
                    achievements
                    recentActivity
                    settings
                }
                .padding(.vertical, 24)
            }
            .background(.background)
            .onAppear {
                vm.userId = authVM.userId ?? ""
            }
            .onChange(of: authVM.userId) { _, newId in
                vm.userId = newId ?? ""
            }
            .sheet(isPresented: $vm.isEditing) {
                // TODO: EditingProfileView
            }
        }
    }
    
    // MARK: Components making up body view
    
    // Account
    private var account: some View {
        VStack(alignment: .leading, spacing: 12) {
            
            // Not logged in
            if authVM.user == nil {
                VStack(alignment: .leading, spacing: 12) {
                    Text("You're not signed in.")
                        .font(.headline)
                    Text("Sign in to save your visited temples, sync across devices, and back up notes and photos.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    if vm.isLoading {
                        HStack {
                            ProgressView()
                                .progressViewStyle(.circular)
                                .scaleEffect(1.4)
                            Text("Signing in...")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(16)
                        .background(
                            RoundedRectangle(cornerRadius: 24)
                                .fill(.ultraThinMaterial)
                                .shadow(radius: 4)
                        )
                    } else {
                        Button(action: { showAuthSheet() }) {
                            HStack(spacing: 8) {
                                Text("Sign in to an account")
                                    .fontWeight(.semibold)
                            }
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 10)
                            .background(.thinMaterial, in: Capsule())
                        }
                        .foregroundStyle(Color(.blue))
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 24)
                        .fill(.ultraThinMaterial)
                        .shadow(radius: 4)
                )
                
            // Logged in
            } else {
                VStack(alignment: .center, spacing: 16) {
                    Avatar(image: vm.avatar)
                        .frame(width: 110, height: 110)
                    
                    // Name
                    if let name = authVM.user?.displayName, !name.isEmpty {
                        Text(name)
                            .font(.title2.weight(.semibold))
                    }
                    
                    // Home temple
                    Label(vm.homeTemple, systemImage: "house.fill")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    
                    if let memberSince = vm.memberSince {
                        Text("Member since \(memberSince.formatted(.dateTime.year().month()))")
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                    }
                    
                    Button("Edit Profile") {
                        vm.onEditProfile?()
                    }
                }
            }
        }
        .padding(.horizontal)
    }
    
    // Stats
    private var stats: some View {
        VStack(alignment: .center, spacing: 12) {
            SectionHeader(title: "Overview")
            LazyVGrid(columns: [GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12)], spacing: 12) {
                StatCard(title: "Total Visits",
                         value: "\(vm.totalVisited)")
                StatCard(title: "Countries Visited",
                         value: "\(vm.countriesVisited)")
                StatCard(title: "Last Visit",
                         value: vm.lastVisit?.templeName ?? "—",
                         subtitle: vm.lastVisit.map { $0.date.formatted(date: .abbreviated, time: .omitted) } ?? nil)
                StatCard(title: "Upcoming",
                         value: vm.upcomingVisit?.templeName ?? "—",
                         subtitle: vm.upcomingVisit.map { $0.date.formatted(date: .abbreviated, time: .omitted) } ?? nil)
            }
        }
        .padding(.horizontal)
    }
    
    // Progress
    private var progress: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(title: "Progress")
            HStack(spacing: 16) {
                ProgressRing(progress: vm.progressFraction)
                    .frame(width: 88, height: 88)
                VStack(alignment: .leading, spacing: 6) {
                    Text("Current goal")
                    Text("\(vm.currentGoal.label)")
                        .font(.headline)
                    Text("So far you’ve checked off \(vm.currentGoal.current) of \(vm.currentGoal.target).")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                Spacer()
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 24)
                    .fill(.ultraThinMaterial)
                    .shadow(radius: 4)
            )
        }
        .padding(.horizontal)
    }
    
    // Achievements
    private var achievements: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(title: "Achievements")
                .padding(.horizontal)
            if vm.badges.isEmpty {
                EmptyState(text: "No badges yet. Start visiting to earn your first one!")
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(vm.badges) { badge in
                            BadgeCard(badge: badge)
                        }
                    }
                    .padding(.horizontal)
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
        .padding(.horizontal)
    }
    
    // Settings
    private var settings: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(title: "Settings")
            VStack(spacing: 8) {
                SettingRow(icon: "bell.badge", title: "Notifications", detail: vm.notificationsEnabled ? "On" : "Off") {
                    vm.onToggleNotifications?()
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
                    .shadow(radius: 4)
            )
            
            // Sign in/out button with respective icons and functions
            Button(action: {
                authVM.user != nil ? authVM.signOut() : showAuthSheet()
            }) {
                HStack(spacing: 8) {
                    if authVM.user != nil {
                        Image(systemName: "rectangle.portrait.and.arrow.right")
                    }
                    Text(authVM.user != nil ? "Sign Out" : "Sign In")
                        .fontWeight(.semibold)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
            }
            .frame(maxWidth: .infinity, alignment: .center)
        }
        .padding(.horizontal)
    }
}
