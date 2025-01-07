//
//  LoginScreen.swift
//  task-manager
//
//  Created by Crhistian David Vergara Gomez on 3/01/25.
//

import SwiftUI

struct LoginScreen: View {
    @Environment(TaskManagerAppViewModel.self) var appDataService
    
    var body: some View {
        @Bindable var loginViewModel = appDataService.loginViewModel
        VStack {
            VStack {
                FormHeader(
                    title: "Iniciar sesión",
                    subtitle: "Inicia sesión para acceder a tus listado de tareas"
                )
                // Inputs
                VStack {
                    UITextField(
                        label: "Correo electrónico",
                        text: $loginViewModel.email,
                        placeholder: "jon.doe@example.com",
                        error: loginViewModel.emailError
                    )
                    .padding(.bottom, 8)
                    UITextField(
                        label: "Contraseña",
                        text: $loginViewModel.password,
                        placeholder: "Escribe tu contraseña",
                        isSecure: true,
                        error: loginViewModel.passwordError
                    )
                }
                .padding(.horizontal, 20)
                // Buttons
                VStack {
                    UIButton(
                        label: loginViewModel.isLoading ? "Cargando..." : "Iniciar sesión",
                        action: loginViewModel.onLogin
                    ).padding(.top, 24)
                    UIButton(
                        label: "Registrate",
                        style: .light,
                        action: loginViewModel.goToRegister
                    )
                    .padding(.top, 8)
                    UIButton(
                        label: "Olvidaste tu contraseña?",
                        style: .outline,
                        action: loginViewModel.goToForgotPassword
                    )
                    .padding(.top, 8)
                }
                .padding(.all, 20)
            }
            .background(.backgroundLight)
            .cornerRadius(12, antialiased: true)
            .padding(.all, 20)
            .multicolorGlow(.aurora)
        }
        .frame(maxHeight: .infinity)
        .background(.backgroundDark)
        .alert(isPresented: $loginViewModel.showError) {
            Alert(title: Text(loginViewModel.errorMessage ?? ""))
        }
    }
    
}

#Preview {
    @Previewable @State var appViewModel = TaskManagerAppViewModel(
        loginViewModel: LoginViewModel(
            backend: BackendServiceTest()
        )
    )
    LoginScreen()
        .environment(appViewModel)
}
