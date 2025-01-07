//
//  UIButton.swift
//  task-manager
//
//  Created by Crhistian David Vergara Gomez on 5/01/25.
//

import SwiftUI

struct UIButton: View {
    enum ButtonStyle {
        case dark, light, outline
    }
    
    let label: String
    var style: ButtonStyle = .dark
    var isFullWidth: Bool = true
    var action: () -> Void
    
    @State private var isPressed: Bool = false
    
    func getBackgroundColor() -> Color {
        if(style == .dark) {
            return Color.black.opacity(isPressed ? 0.8 : 1)
        }
        if(style == .light) {
            return Color.white.opacity(isPressed ? 0.8 : 1)
        }
        return Color.white.opacity(isPressed ? 0.0 : 0.0)
    }
    
    var body: some View {
        Button(action: action) {
            Text(label)
                .frame(maxWidth: isFullWidth ? .infinity : nil)
                .padding()
                .foregroundColor(
                    style == .dark
                    ? .white
                    : .black
                )
                .background(getBackgroundColor())
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(
                            style == .light ?
                            Color.gray: Color.clear,
                            lineWidth: 1
                        )
                )
                .scaleEffect(isPressed ? 0.98 : 1)
                .animation(.easeInOut(duration: 0.1), value: isPressed)
        }
        .background(getBackgroundColor())
        .cornerRadius(8)
        //        .shadow(color: .cyan.opacity(0.5), radius: 2, x: 0, y: 2)
        .onChange(of: isPressed ) {
            if isPressed {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    isPressed = false
                }
            }
        }
        .simultaneousGesture(
            DragGesture(minimumDistance: 0).onChanged { _ in isPressed = true }
        )
    }
}

#Preview {
    VStack {
        VStack(spacing: 20) {
            UIButton(label: "Continuar", style: .dark, action: {
                print("Botón oscuro presionado")
            })
            
            UIButton(label: "Cancelar", style: .light, action: {
                print("Botón claro presionado")
            })
            
            UIButton(label: "Alternativa", style: .outline, action: {
                print("Botón claro presionado")
            })
        }.padding()
    }
    .background(.gray)
    .padding()
}
