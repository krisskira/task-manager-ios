//
//  TaskData.swift
//  task-manager
//
//  Created by Crhistian David Vergara Gomez on 6/01/25.
//

import Foundation

let TaskDataTest: [TaskModel] = [
    TaskModel(id: UUID().uuidString, title: "Grocery Shopping", description: "Buy groceries for the week, including groceries for dinner and breakfast, as well as snacks, beverages, and cleaning supplies", completed: false, createdAt: Date()),
    TaskModel(id: UUID().uuidString, title: "Workout", description: "Complete a 30-minute cardio session", completed: true, createdAt: Date().addingTimeInterval(-3600 * 24)),
    TaskModel(id: UUID().uuidString, title: "Read Book", description: "Finish reading the current chapter", completed: false, createdAt: Date().addingTimeInterval(-3600 * 48)),
    TaskModel(id: UUID().uuidString, title: "Team Meeting", description: "Discuss the project milestones with the team", completed: true, createdAt: Date().addingTimeInterval(-3600 * 72)),
    TaskModel(id: UUID().uuidString, title: "Dentist Appointment", description: "Routine dental check-up", completed: false, createdAt: Date().addingTimeInterval(-3600 * 96)),
    TaskModel(id: UUID().uuidString, title: "Submit Report", description: "Submit the monthly financial report", completed: true, createdAt: Date().addingTimeInterval(-3600 * 120)),
    TaskModel(id: UUID().uuidString, title: "Plan Vacation", description: "Research and book accommodations", completed: false, createdAt: Date().addingTimeInterval(-3600 * 144)),
    TaskModel(id: UUID().uuidString, title: "Clean Garage", description: "Organize tools and boxes in the garage", completed: true, createdAt: Date().addingTimeInterval(-3600 * 168)),
    TaskModel(id: UUID().uuidString, title: "Doctor Visit", description: "Annual physical examination", completed: false, createdAt: Date().addingTimeInterval(-3600 * 192)),
    TaskModel(id: UUID().uuidString, title: "Car Service", description: "Oil change and tire rotation", completed: true, createdAt: Date().addingTimeInterval(-3600 * 216)),
    TaskModel(id: UUID().uuidString, title: "Buy Birthday Gift", description: "Purchase a gift for Sarah's birthday", completed: false, createdAt: Date().addingTimeInterval(-3600 * 240)),
    TaskModel(id: UUID().uuidString, title: "Write Blog Post", description: "Draft the next article for the blog", completed: false, createdAt: Date().addingTimeInterval(-3600 * 264)),
    TaskModel(id: UUID().uuidString, title: "Meditation", description: "Practice mindfulness meditation for 20 minutes", completed: true, createdAt: Date().addingTimeInterval(-3600 * 288)),
    TaskModel(id: UUID().uuidString, title: "Update Resume", description: "Add recent achievements and experiences", completed: false, createdAt: Date().addingTimeInterval(-3600 * 312)),
    TaskModel(id: UUID().uuidString, title: "Laundry", description: "Wash and fold clothes", completed: true, createdAt: Date().addingTimeInterval(-3600 * 336)),
    TaskModel(id: UUID().uuidString, title: "Call Mom", description: "Catch up with mom over the phone", completed: true, createdAt: Date().addingTimeInterval(-3600 * 360)),
    TaskModel(id: UUID().uuidString, title: "Fix Light Fixture", description: "Replace the broken light in the living room", completed: false, createdAt: Date().addingTimeInterval(-3600 * 384)),
    TaskModel(id: UUID().uuidString, title: "Bake Cookies", description: "Try a new cookie recipe", completed: false, createdAt: Date().addingTimeInterval(-3600 * 408)),
    TaskModel(id: UUID().uuidString, title: "Volunteer Work", description: "Help at the local community center", completed: true, createdAt: Date().addingTimeInterval(-3600 * 432)),
    TaskModel(id: UUID().uuidString, title: "Watch Documentary", description: "Learn about space exploration", completed: false, createdAt: Date().addingTimeInterval(-3600 * 456))
]
