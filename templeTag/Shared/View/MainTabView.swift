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
    @State private var isAuthLoading = false
    
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
            
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person")
                }
        }
        .fullScreenCover(isPresented: $authRouter.showAuthSheet) {
            AuthSheetView()
                .environmentObject(authVM)
                .environmentObject(authRouter)
        }
        .interactiveDismissDisabled()
        .onAppear {
            if authVM.user == nil {
                authRouter.showAuthSheet = true
            }
        }
        .onChange(of: authVM.user) { _, user in
            authRouter.showAuthSheet = (user == nil)
        }
    }
}
