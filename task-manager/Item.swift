//
//  Item.swift
//  task-manager
//
//  Created by Crhistian David Vergara Gomez on 3/01/25.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
