//
//  ForgotViewModel.swift
//  task-manager
//
//  Created by Crhistian David Vergara Gomez on 6/01/25.
//
import SwiftUI

protocol ForgotViewModelInteractor {
    var email: String { get set }
    var alertMessage: String? { get set }
    var errorMessage: String? { get }
    var showAlert: Bool { get set }
    var isLoading: Bool { get set }
    var showErrorMessage: Bool { get set }
    func onRecoverPassword() -> Void
}

@Observable
final class ForgotViewModel: ForgotViewModelInteractor {
    
    let backend: BackendInteractor
    let router: TaskManagerAppRouterInteractor

    init(
        backend: BackendInteractor = BackendService.shared,
        router: TaskManagerAppRouterInteractor = TaskManagerAppRouter.shared
    ){
        self.backend = backend
        self.router = router
    }
    
    var email: String = ""
    var alertMessage: String?
    var showAlert: Bool = false
    var showErrorMessage: Bool = false
    var errorMessage: String?
    var isLoading = false
    
    func onRecoverPassword() {
        if(email.isEmpty) {
            errorMessage = "Email es requerido"
            showErrorMessage = true
            return
        }
        showErrorMessage = false
        errorMessage = nil
        isLoading = true
        Task {
            do {
                try await backend.forgotPassword(email: email)
                showAlert = true
                alertMessage = "Se ha enviado un correo con las instrucciones para recuperar la contraseña"
            } catch {
                print(">>> onRecoverPassword error:", error)
                errorMessage = "Ocurrio un error al tratar de cambiar la contraseña, por favor intente más tarde"
                showErrorMessage = true
            }
            isLoading = false
        }
    }
    
    func goToLogin() {
        router.navigateTo(.Login)
    }
    
    func goToSignup() {
        router.navigateTo(.Signup)
    }
}
