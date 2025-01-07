//
//  SignupScreen.swift
//  task-manager
//
//  Created by Crhistian David Vergara Gomez on 3/01/25.
//

import SwiftUI

struct SignupScreen: View {
    @Environment(TaskManagerAppViewModel.self) var appDataService
    
    var body: some View {
        @Bindable var signupViewModel = appDataService.signupViewModel
        VStack {
            VStack {
                ScrollView {
                    // Inputs
                    VStack {
                        // Header
                        FormHeader(
                            title: "Registrate",
                            subtitle: "Crea una cuenta para acceder a tus listado de tareas"
                        )
                        VStack(spacing: 5) {
                            UITextField(
                                label: "Nombre",
                                text: $signupViewModel.firstName,
                                placeholder: "Jon",
                                error: signupViewModel.firstNameValid ? nil : "Este campo es requerido"
                            )
                            UITextField(
                                label: "Apellido",
                                text: $signupViewModel.lastName,
                                placeholder: "Snow",
                                error: signupViewModel.lastNameValid ? nil : "Este campo es requerido"
                            )
                            UITextField(
                                label: "Correo electrónico",
                                text: $signupViewModel.email,
                                placeholder: "jon.snow@gmail.com",
                                keyboardType: .emailAddress,
                                error: signupViewModel.emailValid ? nil : "Este campo es requerido"
                            )
                            UITextField(
                                label: "Contraseña",
                                text: $signupViewModel.password,
                                placeholder: "Password",
                                isSecure: true,
                                error: signupViewModel.passwordValid ? nil : "Este campo es requerido"
                            )
                        }.padding(.all, 16)
                        //  Buttons
                        VStack {
                            UIButton(
                                label: signupViewModel.isLoading ? "Registrando..." : "Registrate",
                                style: .dark,
                                action: signupViewModel.register
                            )
                            .padding(.top, 8)
                            UIButton(
                                label: "Iniciar sesión",
                                style: .light,
                                action: signupViewModel.navigateToLogin
                            ).padding(.top, 8)
                            UIButton(
                                label: "Olvidaste tu contraseña?",
                                style: .outline,
                                action: signupViewModel.navigateToForgotPassword
                            )
                            .padding(.top, 16)
                        }.padding(.all, 16)
                    }
                }
            }
            .background(.backgroundLight)
            .cornerRadius(12, antialiased: true)
            .padding(.all, 20)
            .multicolorGlow(.aurora)
            .alert(isPresented: $signupViewModel.showAlert) {
                Alert(
                    title: Text(signupViewModel.alertMessage),
                    dismissButton:
                            .default(
                                Text("Continuar"),
                                action: signupViewModel.alertAction
                            )
                )
            }
        }
        .frame(maxHeight: .infinity)
        .background(.backgroundDark)
    }
}

#Preview {
    @Previewable @State var appViewModel = TaskManagerAppViewModel(
        signupViewModel: SignupViewModel(
            backend: BackendServiceTest()
        )
    )
    
    SignupScreen()
        .environment(appViewModel)
}


