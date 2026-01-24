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
    @EnvironmentObject var authVM: AuthViewModel
    @EnvironmentObject var authRouter: AuthRouter
    @State private var isAuthLoading = false
    
    var body: some View {
        TabView {
            Tab("Home", systemImage: "house") { HomeView() }
            
            Tab("Search", systemImage: "magnifyingglass") { SearchView() }
            
            Tab("Add", systemImage: "plus") { AddVisitRootView() }
            
            Tab("Map", systemImage: "map") { MapsMainView() }
            
            Tab("Profile", systemImage: "person") { ProfileView() }
        }
        .fullScreenCover(isPresented: $authRouter.showAuthSheet) {
            AuthSheetView()
                .environmentObject(authVM)
                .environmentObject(authRouter)
        }
        .interactiveDismissDisabled()
        .onChange(of: authVM.user) { _, user in
            authRouter.showAuthSheet = (user == nil)
        }
    }
}
