//
//  TaskDetailScreen.swift
//  task-manager
//
//  Created by Crhistian David Vergara Gomez on 4/01/25.
//

import SwiftUI

struct TaskDetailScreen: View {
    let task: TaskModel?
    var body: some View {
        Text("Task Detail Screen \n Task: \(task?.title ?? "")")
    }
}

#Preview {
    @Previewable let task = TaskModel(
        id: "1",
        title: "Titulo",
        description: "descripcion",
        completed: true,
        createdAt: Date())
    TaskDetailScreen(task: task)
}
