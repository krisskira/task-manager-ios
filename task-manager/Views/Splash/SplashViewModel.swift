//
//  SplashViewModel.swift
//  task-manager
//
//  Created by Crhistian David Vergara Gomez on 7/01/25.
//
import Foundation
import Observation

protocol SplashViewModelIterator {
    func didApper()
}

@Observable
final class SplashViewModel: SplashViewModelIterator {
    var router: TaskManagerAppRouterInteractor
    var backend: BackendInteractor
    
    init(
        backend: BackendInteractor = BackendService.shared,
        router: TaskManagerAppRouterInteractor = TaskManagerAppRouter.shared
    ) {
        self.router = router
        self.backend = backend
    }

    func didApper() {
        Task {
            let seconds = 3
            try? await Task.sleep(nanoseconds: UInt64(seconds * 1_000_000_000))
            if(backend.isLoggedIn) {
                router.navigateTo(.Tasks)
            } else {
                router.navigateTo(.Login)
            }
        }
    }
}
