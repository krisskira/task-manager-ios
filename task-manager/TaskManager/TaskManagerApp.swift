//
//  TaskManagerApp.swift
//  TaskManagerApp
//
//  Created by Crhistian David Vergara Gomez on 3/01/25.
//

import SwiftUI
import SwiftData

@main
struct TaskManagerApp: App {
    @State var appViewModel = TaskManagerAppViewModel()
    var body: some Scene {
        WindowGroup {
            TaskManagerView()
                .environment(appViewModel)
        }
    }
}
