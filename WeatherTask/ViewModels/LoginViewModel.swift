//
//  LoginViewModel.swift
//  WeatherTask
//
//  Created by Michael Winkler on 14.02.25.
//

import SwiftUI
import FirebaseAuth

@MainActor
class LoginViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var isPasswordVisible: Bool = false
    @Published var isSignedIn: Bool = false
    @Published var errorMessage: String?
    @Published var navigateToMainTabView = false
    @Published var user: User?
    @Published var isLoginSuccessful = false

    private let userRepository = UserRepository()
    private let errorHandler = ErrorHandler()
    
    init() {
        _ = AuthManager.shared
        fetchCurrentUser()
    }
    
    var isUserSignedIn: Bool {
        AuthManager.shared.isUserSignedIn
    }

    var isLoginButtonEnabled: Bool {
        !email.isEmpty && !password.isEmpty
    }
    
    var loginButtonBackgroundColor: Color {
        isLoginButtonEnabled ? .blue : .gray
    }
        
    private func fetchCurrentUser() {
        Task {
            do {
                if let userID = AuthManager.shared.userID {
                    user = try await userRepository.find(by: userID)
                }
            } catch {
                errorMessage = "The user is not signed in."
            }
        }
    }
    
    func signIn() async {
        guard EmailValidator.isValid(email) else {
            DispatchQueue.main.async {
                self.errorMessage = "Ungültige E-Mail-Adresse."
            }
            return
        }
        
        do {
            try await AuthManager.shared.signIn(email: email, password: password)
            let userID = AuthManager.shared.userID!
            let fetchedUser = try await userRepository.find(by: userID)
            
            DispatchQueue.main.async {
                self.user = fetchedUser
                self.isSignedIn = true
                self.isLoginSuccessful = true
                self.errorMessage = nil
                self.navigateToMainTabView = true
            }
        } catch let error as NSError {
            DispatchQueue.main.async {
                switch AuthErrorCode(rawValue: Int(UInt(error.code))) {
                case .emailAlreadyInUse:
                    self.errorMessage = "E-Mail wird bereits verwendet."
                case .wrongPassword:
                    self.errorMessage = "Falsches Passwort."
                case .userNotFound:
                    self.errorMessage = "Benutzer nicht gefunden."
                case .weakPassword:
                    self.errorMessage = "Passwort zu schwach."
                default:
                    self.errorMessage = "Unbekannter Fehler: \(error.localizedDescription)"
                }
            }
        }
    }

    func signOut() {
        Task {
            try? AuthManager.shared.signOut()
            user = nil
        }
    }
}
