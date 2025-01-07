//
//  GlobalNavigationModel.swift
//  task-manager
//
//  Created by Crhistian David Vergara Gomez on 4/01/25.
//

import SwiftUI

enum Routes: Hashable {
    case Login
    case Signup
    case ForgotPassword
    case Tasks
    case TaskDetails(task: TaskModel?)
}

protocol TaskManagerAppRouterInteractor {
    var routesStack: [Routes] { get set }
    func navigateTo(_ route: Routes)
    func navigateBack()
}

@Observable
final class TaskManagerAppRouter: TaskManagerAppRouterInteractor {
    
    static let shared = TaskManagerAppRouter()

    var routesStack: [Routes] = []
    
    func navigateTo(_ route: Routes) {
        routesStack.append(route)
    }
    
    func navigateBack() {
        routesStack.removeLast()
    }
}
