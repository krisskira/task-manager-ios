//
//  TaskManagerAppRouter.swift
//  task-manager
//
//  Created by Crhistian David Vergara Gomez on 7/01/25.
//

import Observation

@Observable
final class TaskManagerAppRouterTest: TaskManagerAppRouterInteractor, SpyFunction {
    
    var called: SpyCallTests = .init()

    var routesStack: [Routes] = [] {
        didSet {
            let _ = called.spyCall("routesStack", routesStack)
        }
    }
    
    func navigateTo(_ route: Routes) {
        let _ = called.spyCall("navigateTo", ["route": route])
        routesStack.append(route)
    }
    
    func navigateBack() {
        let _ = called.spyCall("navigateBack",  ["route": nil])
        routesStack.removeLast()
    }
}
