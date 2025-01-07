//
//  LoginViewModel.swift
//  task-manager
//
//  Created by Crhistian David Vergara Gomez on 7/01/25.
//
import Foundation
import Observation

protocol LoginViewModelInteractor {
    var email: String { get set }
    var password: String { get set }

    var errorMessage: String? { get set }
    var showError: Bool { get set }
    var isLoading: Bool { get set }
    
    func onLogin()
    func goToRegister()
    func goToForgotPassword()
}

@Observable
final class LoginViewModel: LoginViewModelInteractor {
    let backend: BackendInteractor
    let router: TaskManagerAppRouterInteractor
    
    init(
        backend: BackendInteractor = BackendService.shared,
        router: TaskManagerAppRouterInteractor = TaskManagerAppRouter.shared
    ) {
        self.backend = backend
        self.router = router
    }
    
    var email: String = ""
    var password: String = ""
    
    var emailError: String?
    var passwordError: String?
    
    var errorMessage: String?
    var showError: Bool = false
    var isLoading: Bool = false
    
    func onLogin() {
        Task {
            isLoading = true
            do {
                if email.isEmpty {
                    emailError = "El email es requerido"
                }
                
                if password.isEmpty {
                    passwordError = "La contraseña es requerida"
                }
                
                if email.isEmpty || password.isEmpty {
                   isLoading = false
                   return
                }

                let token = try await backend.login(email: email, password: password)

                if (token.token?.isEmpty) != nil {
//                    DispatchQueue.main.async(execute: {
//                        // your code here
//                        self.email = ""
//                        self.password = ""
//                        self.errorMessage = nil
//                        self.showError = false
//                        self.emailError = nil
//                        self.passwordError = nil
//                    })
                    router.navigateTo(.Tasks)
                } else {
                    throw NSError(domain: token.message ?? "Error al iniciar sesion, intente de nuevo", code: 0)
                }
            } catch {
                showError = true
                errorMessage = (error as NSError).domain
            }
            isLoading = false
        }
    }
    
    func goToRegister() {
        router.navigateTo(.Signup)
    }
    
    func goToForgotPassword() {
        router.navigateTo(.ForgotPassword)
    }
}

