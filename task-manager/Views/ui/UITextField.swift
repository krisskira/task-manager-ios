//
//  UITextField.swift
//  task-manager
//
//  Created by Crhistian David Vergara Gomez on 5/01/25.
//
import SwiftUI

struct UITextField: View {
    let label: String
    @Binding var text: String
    var placeholder: String = ""
    var isSecure: Bool = false
    var keyboardType: UIKeyboardType = .default
    var autocapitalization: TextInputAutocapitalization = .never
    var error: String? = nil
    
    @State private var isTextVisible: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(label)
                .font(.subheadline)
                .foregroundColor(.gray)
            
            ZStack {
                if isSecure && !isTextVisible {
                    SecureField(placeholder, text: $text)
                        .padding(.trailing, 40)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .strokeBorder(error == nil ? Color.gray : Color.red, lineWidth: 1)
                        )
                } else {
                    TextField(placeholder, text: $text)
                        .keyboardType(keyboardType)
                        .textInputAutocapitalization(autocapitalization)
                        .padding(.trailing, isSecure ? 40 : 0)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .strokeBorder(error == nil ? Color.gray : Color.red, lineWidth: 1)
                        )
                }
                
                if isSecure {
                    HStack {
                        Spacer()
                        Button(action: {
                            isTextVisible.toggle()
                        }) {
                            Image(systemName: isTextVisible ? "eye.slash" : "eye")
                                .foregroundColor(.gray)
                        }
                        .padding(.trailing, 8)
                    }
                }
            }
            
            if let errorMessage = error {
                Text(errorMessage)
                    .font(.caption)
                    .foregroundColor(.red)
            }
        }
    }
}

#Preview {
    @Previewable @State var password: String = ""
    
    VStack {
        UITextField(
            label: "Contraseña",
            text: $password,
            placeholder: "Ingresa tu contraseña",
            isSecure: true,
            error: "La contraseña debe tener al menos 6 caracteres"
        )
    }
    .padding()
}

