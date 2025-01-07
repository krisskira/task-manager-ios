//
//  TaskModel.swift
//  task-manager
//
//  Created by Crhistian David Vergara Gomez on 3/01/25.
//

import SwiftUI

struct TaskModel: Codable, Hashable, Identifiable {
    var id: String
    var title: String
    var description: String
    var completed: Bool
    var createdAt: Date
    
    enum CodingKeys: String, CodingKey {
        case id = "uuid"
        case title
        case description
        case completed
        case createdAt
    }
    
    init (id: String, title: String, description: String, completed: Bool, createdAt: Date) {
        self.id = id
        self.title = title
        self.description = description
        self.completed = completed
        self.createdAt = createdAt
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        description = try container.decode(String.self, forKey: .description)
        completed = try container.decode(Bool.self, forKey: .completed)
        
        // Decodificar la fecha desde un string ISO 8601 con milisegundos
        let dateString = try container.decode(String.self, forKey: .createdAt)
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        
        guard let date = dateFormatter.date(from: dateString) else {
            throw DecodingError.dataCorruptedError(
                forKey: .createdAt,
                in: container,
                debugDescription: "Fecha en formato incorrecto: \(dateString)"
            )
        }
        createdAt = date
    }
}
