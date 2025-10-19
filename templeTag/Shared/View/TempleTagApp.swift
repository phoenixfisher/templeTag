//
//  TempleTagApp.swift
//  templeTag
//
//  Created by Phoenix Fisher on 10/19/25.
//

import SwiftUI

@main
struct TempleTagApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject private var authVM = AuthViewModel()
    @StateObject private var authRouter = AuthRouter()

    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environmentObject(authVM)
                .environmentObject(authRouter)
        }
    }
}
