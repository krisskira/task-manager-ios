//
//  ContentView.swift
//  task-manager
//
//  Created by Crhistian David Vergara Gomez on 3/01/25.
//

import SwiftUI
import SwiftData

struct TaskManagerView: View {
    @Environment(TaskManagerAppViewModel.self) var appViewModel
    var body: some View {
        @Bindable var routesStack = appViewModel.router
        NavigationStack(path: $routesStack.routesStack) {
            SplashScreen()
                .navigationDestination(for: Routes.self) { route in
                    switch route {
                    case .Login:
                        LoginScreen()
                            .navigationBarBackButtonHidden()
                    case .Signup:
                        SignupScreen()
                            .transition(.move(edge: .bottom))
                            .navigationBarBackButtonHidden()
                    case .ForgotPassword:
                        ForgotScreen()
                            .transition(.move(edge: .bottom))
                            .navigationBarBackButtonHidden()
                    case .Tasks:
                        TasksScreen()
                            .navigationBarBackButtonHidden()
                    case .TaskDetails(let task):
                        TaskDetailScreen(task: task)
                    }
                }
            
        }
    }
}

#Preview {
    @Previewable @State var appViewModel = TaskManagerAppViewModel(
        splashViewModel: SplashViewModel(backend: BackendServiceTest()),
        signupViewModel: SignupViewModel(backend: BackendServiceTest()),
        loginViewModel: LoginViewModel(backend: BackendServiceTest()),
        forgotViewModel: ForgotViewModel(backend: BackendServiceTest()),
        taskViewModel: TaskViewModel(backend: BackendServiceTest())
    )
    
    TaskManagerView()
        .environment(appViewModel)
}
