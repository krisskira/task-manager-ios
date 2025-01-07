//
//  WaitForAsyncTasks.swift
//  task-manager
//
//  Created by Crhistian David Vergara Gomez on 7/01/25.
//
import XCTest

// Helper para manejar tareas asincrónicas
extension XCTestCase {
    func waitForAsyncTasks() async {
        try? await Task.sleep(nanoseconds: 500_000_000) // Esperar 500ms para completar las tareas asincrónicas
    }
}
