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
    @Binding var isLoading: Bool
    
    var onApple: () -> Void = { }
    var onGoogle: () -> Void = { }
    var onSignUp: () -> Void = { }
    var onLogIn: () -> Void = { }
    
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
                    // Apple
                    Button(action: onApple) {
                        HStack(spacing: 8) {
                            Image(systemName: "apple.logo")
                                .offset(y: -2)
                            Text("Continue with Apple")
                        }
                    }
                    .buttonStyle(AuthButton(tint: .white, textColor: .black))
                    
                    // Google
                    Button(action: onGoogle) {
                        HStack(spacing: 8) {
                            Image(systemName: "g.circle")
                            Text("Continue with Google")
                        }
                    }
                    .buttonStyle(AuthButton(tint: .blue))
                    
                    // Sign up
                    Button(action: onSignUp) {
                        Text("Sign Up")
                    }
                    .buttonStyle(AuthButton())
                    
                    // Log in
                    Button(action: onLogIn) {
                        Text("Log In")
                    }
                    .buttonStyle(AuthButton(outlined: true))
                }
                .padding(.horizontal)
                .padding(.top)
                .padding(.bottom, 30)
                .background(colorScheme == .dark ? Color(.secondarySystemBackground) : .black)
                .cornerRadius(34)
            }
            
            // Loading overlay
            if isLoading {
                Color.black.opacity(0.35).ignoresSafeArea()
                ProgressView()
                    .progressViewStyle(.circular)
                    .controlSize(.large)
                    .tint(.white)
            }
        }
        .interactiveDismissDisabled(isLoading)
        .ignoresSafeArea(edges: .bottom)
    }
}

#Preview {
    struct PreviewWrapper: View {
        @State private var isLoading = false
        var body: some View {
            AuthSheetView(isLoading: $isLoading)
        }
    }
    return PreviewWrapper()
}
