//
//  AppDataService.swift
//  task-manager
//
//  Created by Crhistian David Vergara Gomez on 4/01/25.
//

import SwiftUI
import SwiftData

@Observable
final class TaskManagerAppViewModel {
    
    var splashViewModel: SplashViewModel
    var signupViewModel: SignupViewModel
    var loginViewModel: LoginViewModel
    var forgotViewModel: ForgotViewModel
    var taskViewModel: TaskViewModel
    var userViewModel: UserViewModel
    var router: TaskManagerAppRouter
    
    init(
        router: TaskManagerAppRouter = TaskManagerAppRouter.shared,
        splashViewModel: SplashViewModel = SplashViewModel(),
        signupViewModel: SignupViewModel = SignupViewModel(),
        loginViewModel: LoginViewModel = LoginViewModel(),
        forgotViewModel: ForgotViewModel = ForgotViewModel(),
        taskViewModel: TaskViewModel = TaskViewModel(),
        userViewModel: UserViewModel = UserViewModel()
    ) {
        self.router = router
        self.splashViewModel = splashViewModel
        self.signupViewModel = signupViewModel
        self.loginViewModel = loginViewModel
        self.forgotViewModel = forgotViewModel
        self.taskViewModel = taskViewModel
        self.userViewModel = userViewModel
    }
    
    var errorMessage: String?
    var errors: Error?
    
    func logout() {
        Task {
            errors = nil
            errorMessage = nil
            taskViewModel = TaskViewModel()
            userViewModel = UserViewModel()
            router.navigateTo(.Login)
        }
    }
}
