//
//  AuthViewModel.swift
//  templeTag
//
//  Created by Phoenix Fisher on 10/14/25.
//

import FirebaseAuth
import GoogleSignIn
import UIKit
import Combine

@MainActor
final class AuthViewModel: ObservableObject {
    @Published var user: User?
    private var handle: AuthStateDidChangeListenerHandle?
    
    init() {
        handle = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            self?.user = user
        }
    }
    deinit { if let h = handle { Auth.auth().removeStateDidChangeListener(h) } }
    
    func signInWithGoogle(presenting vc: UIViewController) async throws {
        let result = try await GIDSignIn.sharedInstance.signIn(withPresenting: vc)
        guard let idToken = result.user.idToken else { return }
        let cred = GoogleAuthProvider.credential(
            withIDToken: idToken.tokenString,
            accessToken: result.user.accessToken.tokenString
        )
        _ = try await Auth.auth().signIn(with: cred)
    }
    
    func signOut() { try? Auth.auth().signOut() }
}
