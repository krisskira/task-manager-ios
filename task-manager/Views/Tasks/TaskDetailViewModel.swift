
//
//  TaskViewDetailModelProtocol.swift
//  task-manager
//
//  Created by Crhistian David Vergara Gomez on 7/01/25.
//



import Foundation
import Observation

protocol TaskDetailViewModelProtocol {
    var errorMessage: String? { get set }
    var showError: Bool { get set }
    var isLoading: Bool { get set }
    var showSuccess: Bool { get set }
    func createTask(_ task: CreateTaskModel)
    func updateTask(_ task: TaskModel)
    func deleteTask(_ taskId: String)
    var onCreatedTask: ((_ task: TaskModel) ->  Void)? { get }
    var onUpdatedTask: ((_ task: TaskModel) ->  Void)? { get }
    var onDeletedTask: ((_ taskId: String) ->  Void)? { get }
}

@Observable
final class TaskDetailViewModel: TaskDetailViewModelProtocol {

    var backend: BackendInteractor
    var router: TaskManagerAppRouterInteractor
    var task: TaskModel
    var errorMessage: String?
    var showError: Bool = false
    var isLoading: Bool = false
    var showSuccess: Bool = false
    
    var onCreatedTask: ((TaskModel) -> Void)?
    var onUpdatedTask: ((TaskModel) -> Void)?
    var onDeletedTask: ((String) -> Void)?

    init(
        backend: BackendInteractor = BackendService.shared,
        router: TaskManagerAppRouterInteractor = TaskManagerAppRouter.shared,
        task: TaskModel
    ) {
        self.backend = backend
        self.router = router
        self.task = task
    }
    
    func createTask(_ task: CreateTaskModel) {
       Task {
           isLoading = true
            do {
                let newTask = try await backend.createTask(data: task)
                onCreatedTask?(newTask)
                showSuccess = true
                // self.tasks.append(newTask)
            } catch {
                print(">>> createTask Error: \(error.localizedDescription)", error)
                errorMessage = "No se pudo crear la tarea, intente más tarde"
                showError = true
            }
           isLoading = false
        }
    }
    
    func updateTask(_ task: TaskModel) {
        Task {
            isLoading = true
            do {
                try await backend.updateTask(
                    id: task.id,
                    data: TaskUpdateModel(
                        title: task.title,
                        description: task.description,
                        completed: task.completed
                    )
                )
                // if let index = self.tasks.firstIndex(where: { task.id == $0.id } ) {
                //     self.tasks[index] = task
                // }
                onUpdatedTask?(task)
                showSuccess = true
            } catch {
                print(">>> updateTask Error: \(error.localizedDescription)", error)
                errorMessage = "En este momento no se puede actualizar la tarea, intente más tarde"
                showError = true
            }
            isLoading = false
        }
    }
    
    func deleteTask(_ taskId: String) {
        Task {
            isLoading = true
            do {
                try await backend.deleteTask(id: taskId)
                // tasks.removeAll { taskId == $0.id }
                showSuccess = true
            } catch {
                print(">>> Deleted Task Error: \(error.localizedDescription)", error)
                errorMessage = "En este momento no se puede eliminar la tarea, intente más tarde"
                showError = true
            }
            onDeletedTask?(taskId)
            isLoading = false
        }
    }
}
