//
//  SignupViewModel.swift
//  task-manager
//
//  Created by Crhistian David Vergara Gomez on 7/01/25.
//
import Foundation
import Observation

protocol SignupViewModelProtocol {
    var email: String { get set }
    var password: String { get set }
    var firstName: String { get set }
    var lastName: String { get set }
    
    var emailValid: Bool { get }
    var passwordValid: Bool { get }
    var firstNameValid: Bool { get }
    var lastNameValid: Bool { get }
    
    var alertMessage: String { get set }
    var showAlert: Bool { get }
    
    var isLoading: Bool { get }
    var isSuccess: Bool { get }
    
    func register() -> Void
    func alertAction() -> Void
    func navigateToForgotPassword() -> Void
    func navigateToLogin() -> Void
}

@Observable
final class SignupViewModel: SignupViewModelProtocol {
    
    
    var backend: BackendInteractor
    var router: TaskManagerAppRouterInteractor
    
    init (
        backend: BackendInteractor = BackendService.shared,
        router: TaskManagerAppRouterInteractor = TaskManagerAppRouter.shared
    ) {
        self.backend = backend
        self.router = router
    }
    
    var email: String = ""
    var password: String = ""
    var firstName: String = ""
    var lastName: String = ""
    
    var emailValid: Bool = true
    var passwordValid: Bool = true
    var firstNameValid: Bool = true
    var lastNameValid: Bool = true
    var confirmPasswordValid: Bool = true
    
    var alertMessage: String = ""
    var showAlert: Bool = false
    var isSuccess: Bool = false
    
    var isLoading: Bool = false
    
    func register() {
        Task {
            isLoading = true
            do {
                if firstName.isEmpty { firstNameValid = false }
                if lastName.isEmpty { lastNameValid = false }
                if email.isEmpty { emailValid = false }
                if password.isEmpty { passwordValid = false }
                
                if !emailValid || !passwordValid || !firstNameValid || !lastNameValid {
                    isLoading = false
                    return
                }
                
                let data = RegisterModel(
                    firstName: firstName,
                    lastName: lastName,
                    email: email,
                    password: password
                )
                
                try await backend.register(data: data)
                isSuccess = true
                alertMessage = "Se ha creado la cuenta correctamente"
                showAlert = true
            } catch {
                print(">>> Register error: ",error)
                isSuccess = false
                alertMessage = "No es posible crear la cuenta en este momento, por favor intente más tarde"
                showAlert = true
            }
            isLoading = false
        }
    }
    
    func alertAction() {
        if isSuccess {
            router.navigateTo(.Login)
            return
        }
        showAlert = false
        alertMessage = ""
    }
    
    func navigateToLogin() -> Void {
        router.navigateTo(.Login)
    }
    func navigateToForgotPassword() {
        router.navigateTo(.ForgotPassword)
    }
}
