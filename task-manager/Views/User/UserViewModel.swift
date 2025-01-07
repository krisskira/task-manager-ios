//
//  UserViewModel.swift
//  task-manager
//
//  Created by Crhistian David Vergara Gomez on 7/01/25.
//

import Foundation
import Observation

protocol UserViewModelInteractor {
    
}

@Observable
final class UserViewModel: UserViewModelInteractor {
    //    func getUser() async throws {
    //        do {
    //            let user = try await backend.getUser()
    //            self.user = user.data
    //        } catch {
    //            print(">>> getUser Error: \(error.localizedDescription)", error)
    //            errorMessage = error.localizedDescription
    //            errors = error
    //        }
    //    }
    //
    //    func updateUser(_ user: UserUpdateModel) async throws {
    //        do {
    //            try await backend.updateUser(data: user)
    //            self.user = UserModel(
    //                firstName: user.firstName ?? self.user!.firstName,
    //                lastName: user.lastName ?? self.user!.lastName,
    //                email: user.email ?? self.user!.email
    //            )
    //        } catch {
    //            print(">>> updateUser Error: \(error.localizedDescription)", error)
    //            errorMessage = error.localizedDescription
    //            errors = error
    //        }
    //    }
}
