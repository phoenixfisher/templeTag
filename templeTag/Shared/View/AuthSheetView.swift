//
//  AuthSheetView.swift
//  templeTag
//
//  Created by Phoenix Fisher on 10/18/25.
//

import SwiftUI
import GoogleSignIn

struct AuthSheetView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var colorScheme
    @EnvironmentObject var authVM: AuthViewModel
    @EnvironmentObject var authRouter: AuthRouter
    @State private var isAuthLoading: Bool = false
    
    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()
            
            // Close button
            VStack {
                HStack {
                    Spacer()
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .fontWeight(.semibold)
                            .foregroundStyle(Color(.secondaryLabel))
                            .frame(width: 30, height: 30)
                            .background(.ultraThinMaterial, in: Circle())
                    }
                }
                Spacer()
            }
            .padding()
            
            VStack(spacing: 24) {
                Spacer()
                Text("Tag You're It!")
                    .font(.largeTitle)
                    .bold()
                    .opacity(0.9)
                    .minimumScaleFactor(0.5)
                    .padding()
                    .offset(y: 20)
                
                Spacer()
                // Auth buttons
                VStack(spacing: 10) {
                    onApple
                    onGoogle
                    onSignUp
                    onLogIn
                }
                .padding(.horizontal)
                .padding(.top)
                .padding(.bottom, 30)
                .background(colorScheme == .dark ? Color(.secondarySystemBackground) : .black)
                .cornerRadius(34)
            }
            
            // Loading overlay
            if isAuthLoading {
                Color.black.opacity(0.35).ignoresSafeArea()
                ProgressView()
                    .progressViewStyle(.circular)
                    .controlSize(.large)
                    .tint(.white)
            }
        }
        .interactiveDismissDisabled(isAuthLoading)
        .ignoresSafeArea(edges: .bottom)
    }
    
    private var onApple: some View {
        Button {
            
        } label: {
            HStack(spacing: 8) {
                Image(systemName: "apple.logo")
                    .offset(y: -2)
                Text("Continue with Apple")
            }
        }
        .buttonStyle(AuthButton(tint: .white, textColor: .black))
    }
    
    private var onGoogle: some View {
        Button {
            guard let presenter = UIApplication.shared.connectedScenes
                .compactMap({ ($0 as? UIWindowScene)?.keyWindow?.rootViewController })
                .first else { return }
            withAnimation(.easeInOut) { isAuthLoading = true }
            Task {
                do {
                    try await authVM.signInWithGoogle(presenting: presenter)
                } catch { print("Sign-in error:", error) }
                isAuthLoading = false
            }
        } label: {
            HStack(spacing: 8) {
                Image(systemName: "g.circle")
                Text("Continue with Google")
            }
        }
        .buttonStyle(AuthButton(tint: .blue))
    }
    
    private var onSignUp: some View {
        Button {
            
        } label: {
            Text("Sign Up")
        }
        .buttonStyle(AuthButton())
    }
    
    private var onLogIn: some View {
        Button {
            
        } label: {
            Text("Log In")
        }
        .buttonStyle(AuthButton(outlined: true))
    }
}

#Preview {
    struct PreviewWrapper: View {
        @StateObject private var authVM = AuthViewModel()
        @StateObject private var authRouter = AuthRouter()
        var body: some View {
            AuthSheetView()
                .environmentObject(authVM)
                .environmentObject(authRouter)
        }
    }
    return PreviewWrapper()
}
