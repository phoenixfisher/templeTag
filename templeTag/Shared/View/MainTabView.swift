//
//  MainTabView.swift
//  templeTag
//
//  Created by Phoenix Fisher on 10/9/25.
//

import SwiftUI
import UIKit
import FirebaseAuth

struct MainTabView: View {
    @StateObject private var authVM = AuthViewModel()
    @StateObject private var authRouter = AuthRouter()
    @StateObject private var profileVM = ProfileViewModel()
    
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
            
            SearchView()
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }
            
            MapsMainView()
                .tabItem {
                    Label("Map", systemImage: "map")
                }
            
            ProfileView(vm: profileVM)
                .tabItem {
                    Label("Profile", systemImage: "person")
                }
        }
        .fullScreenCover(isPresented: $authRouter.showAuthSheet) {
            AuthSheetView(
                isLoading: $profileVM.isLoading,
                onApple: {
                    
                },
                onGoogle: {
                    guard let presenter = UIApplication.shared.connectedScenes
                        .compactMap({ ($0 as? UIWindowScene)?.keyWindow?.rootViewController })
                        .first else { return }
                    withAnimation(.easeInOut) { profileVM.isLoading = true }
                    Task {
                        do {
                            try await authVM.signInWithGoogle(presenting: presenter)
                        } catch {
                            print("Sign-in error:", error)
                        }
                        profileVM.isLoading = false
                    }
                },
                onSignUp: {
                    
                },
                onLogIn: {
                    
                }
            )
            .presentationDetents([.large])
            .interactiveDismissDisabled()
        }
        .onAppear {
            profileVM.onSignIn = {
                withAnimation(.easeInOut) { authRouter.showAuthSheet = true }
            }
            
            if authVM.user == nil {
                authRouter.showAuthSheet = true
            }
            
            // Signing out
            profileVM.onSignOut = { authVM.signOut() }
        }
        .onChange(of: authVM.user?.uid) {
            // Keep ProfileViewModel in sync with auth state
            let u = authVM.user
            profileVM.displayName = u?.displayName ?? u?.email ?? ""
            if let name = u?.displayName {
                let parts = name.split(separator: " ")
                let initials = parts.prefix(2).compactMap { $0.first.map(String.init) }.joined()
                profileVM.initials = initials.uppercased()
            }
            
            // Update boolean
            authRouter.showAuthSheet = u == nil ? true : false
        }
    }
}
