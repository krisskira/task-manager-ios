//
//  MulticolorGlow.swift
//  task-manager
//
//  Created by Crhistian David Vergara Gomez on 5/01/25.
//

import SwiftUI

enum GradientStyle {
    case plain
    case neon
    case sunset
    case aurora
    case flame
    case galaxy
    case lime
    case mystic
    
    var gradient: Gradient {
        switch self {
        case .plain:
            return Gradient(colors: [])
        case .neon:
            return Gradient(colors: [Color.green.opacity(0.8), Color.blue.opacity(0.8)])
        case .sunset:
            return Gradient(colors: [Color.yellow.opacity(0.8), Color.red.opacity(0.8)])
        case .aurora:
            return Gradient(colors: [Color.cyan.opacity(0.6), Color.blue.opacity(0.6)])
        case .flame:
            return Gradient(colors: [Color.orange.opacity(0.8), Color.red.opacity(0.8)])
        case .galaxy:
            return Gradient(colors: [Color.purple.opacity(0.7), Color.blue.opacity(0.7)])
        case .lime:
            return Gradient(colors: [Color.green.opacity(0.8), Color.yellow.opacity(0.8)])
        case .mystic:
            return Gradient(colors: [Color.gray.opacity(0.6), Color.white.opacity(0.6)])
        }
    }
}

extension View {
    func multicolorGlow(_ style: GradientStyle = .plain) -> some View {
        
        return  self
            .background(
                AngularGradient(
                    gradient:style.gradient,
                    center: .top
                )
            )
            .mask(self.blur(radius: 5))
            .overlay(self.blur(radius: 5 - CGFloat(1 * 5)))
        
        //        return VStack {
        //            ZStack {
        //            if style == .plain {
        //                self
        //            } else {
        //                ForEach(0..<2) { i in
        //                    Rectangle()
        //                        .fill(
        //                            //                            RadialGradient(
        //                            //                                gradient:style.gradient,
        //                            //                                center: .center,
        //                            //                                startRadius: 10,
        //                            //                                endRadius: 100)
        //                            AngularGradient(
        //                                gradient:style.gradient,
        //                                center: .top
        //                            )
        //                        )
        ////                        .frame(width: .infinity, height: .infinity)
        //                        .frame(width: .infinity)
        //                        .mask(self.blur(radius: 5))
        //                        .overlay(self.blur(radius: 5 - CGFloat(i * 5)))
        //                }
        //            }
        //            }
        //        }
        //        .frame(width: .infinity)
    }
}
