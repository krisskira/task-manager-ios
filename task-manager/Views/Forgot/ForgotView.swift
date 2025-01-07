//
//  ForgotScreen.swift
//  task-manager
//
//  Created by Crhistian David Vergara Gomez on 3/01/25.
//

import SwiftUI
import Observation

struct ForgotScreen: View {
    @Environment(TaskManagerAppViewModel.self) private var appDataService

    var body: some View {
        @Bindable var forgotViewModel = appDataService.forgotViewModel
        VStack {
            VStack {
                // Header
                FormHeader(
                    title: "Recuperar contraseña",
                    subtitle: "Ingresa tu correo electrónico se te enviará información para recuperar tu contraseña"
                )
                // Inputs
                VStack {
                    UITextField(
                        label: "Correo electrónico",
                        text: $forgotViewModel.email,
                        placeholder: "jon.doe@example.com",
                        error: forgotViewModel.errorMessage
                    )
                }
                .padding(.horizontal, 16)
                //  Buttons
                VStack {
                    UIButton(
                        label: forgotViewModel.isLoading ? "Recuperando..." : "Recuperar",
                        style: .dark,
                        action: forgotViewModel.onRecoverPassword
                    ) .padding(.top, 8)
                    UIButton(
                        label: "Iniciar sesión",
                        style: .light,
                        action: forgotViewModel.goToLogin
                    ).padding(.top, 24)
                    UIButton(
                        label: "Registrarte",
                        style: .light,
                        action: forgotViewModel.goToSignup
                    )
                }.padding(.all, 16)
            }
            .background(.backgroundLight)
            .cornerRadius(12, antialiased: true)
            .padding(.all, 20)
            .multicolorGlow(.aurora)
        }
        .frame(maxHeight: .infinity)
        .background(.backgroundDark)
        .alert(isPresented: $forgotViewModel.showAlert) {
            Alert(title: Text(forgotViewModel.alertMessage ?? ""))
        }
    }
}

#Preview {
    @Previewable @State var appViewModel = TaskManagerAppViewModel(
        forgotViewModel: ForgotViewModel(
            backend: BackendServiceTest()
        )
    )

    ForgotScreen()
        .environment(appViewModel)
}
