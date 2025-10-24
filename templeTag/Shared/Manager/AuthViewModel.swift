//
//  AuthViewModel.swift
//  templeTag
//
//  Created by Phoenix Fisher on 10/14/25.
//

import FirebaseAuth
import AuthenticationServices
import GoogleSignIn
import UIKit
import Combine
import CryptoKit

@MainActor
final class AuthViewModel: ObservableObject {
    @Published var user: User?
    private var handle: AuthStateDidChangeListenerHandle?
    private var currentNonce: String?
    
    var userId: String? { user?.uid }
    
    init() {
        handle = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            self?.user = user
        }
    }
    deinit { if let h = handle { Auth.auth().removeStateDidChangeListener(h) } }
    
    /// Call this from SignInWithAppleButton(.signIn) onRequest
    func prepareAppleSignIn(_ request: ASAuthorizationAppleIDRequest) {
        request.requestedScopes = [.fullName, .email]
        let rawNonce = randomNonceString()
        currentNonce = rawNonce
        request.nonce = sha256(rawNonce)
    }
    
    func signInWithApple(credential: ASAuthorizationAppleIDCredential) async throws {
        guard let tokenData = credential.identityToken,
              let tokenString = String(data: tokenData, encoding: .utf8) else {
            throw URLError(.badServerResponse)
        }
        
        guard let rawNonce = currentNonce else {
            throw URLError(.userAuthenticationRequired)
        }
        
        let firebaseCredential = OAuthProvider.appleCredential(
            withIDToken: tokenString,
            rawNonce: rawNonce,
            fullName: credential.fullName
        )
        
        _ = try await Auth.auth().signIn(with: firebaseCredential)
    }
    
    func signInWithGoogle(presenting vc: UIViewController) async throws {
        let result = try await GIDSignIn.sharedInstance.signIn(withPresenting: vc)
        guard let idToken = result.user.idToken else { return }
        let cred = GoogleAuthProvider.credential(
            withIDToken: idToken.tokenString,
            accessToken: result.user.accessToken.tokenString
        )
        _ = try await Auth.auth().signIn(with: cred)
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            self.user = nil
            GIDSignIn.sharedInstance.signOut()
        } catch {
            print("Sign out failed:", error.localizedDescription)
        }
    }
}

// MARK: - Nonce helpers
private func randomNonceString(length: Int = 32) -> String {
    precondition(length > 0)
    let charset: [Character] = Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
    var result = ""
    var remaining = length
    while remaining > 0 {
        var random: UInt8 = 0
        let status = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
        if status != errSecSuccess { fatalError("Unable to generate nonce") }
        if random < charset.count {
            result.append(charset[Int(random % UInt8(charset.count))])
            remaining -= 1
        }
    }
    return result
}

private func sha256(_ input: String) -> String {
    let inputData = Data(input.utf8)
    let hashed = SHA256.hash(data: inputData)
    return hashed.map { String(format: "%02x", $0) }.joined()
}
