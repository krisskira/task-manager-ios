//
//  UserModel.swift
//  task-manager
//
//  Created by Crhistian David Vergara Gomez on 5/01/25.
//

struct UserModel: Codable, Hashable {
    let firstName: String
    let lastName: String
    let email: String
}
