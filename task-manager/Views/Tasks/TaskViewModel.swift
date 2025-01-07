//
//  TaskViewModel.swift
//  task-manager
//
//  Created by Crhistian David Vergara Gomez on 7/01/25.
//

import Foundation
import Observation
import SwiftUICore
import Combine

protocol TaskViewModelProtocol {
    var colorfilterAllTasks: Color { get }
    var colorfilterCompletedTasks: Color { get }
    var colorfilterIncompletedTasks: Color { get }

    var filters: FilterParameters { get set }
    func filterByState(_ state: Bool?)

    func loadTasks(_ filters: FilterParameters)
    func retryLoadTasks()

    func goToAddTask()
    func deleteTask(_ taskId: String)
    func goToEditTask(_ task: TaskModel)

    func goToProfile()
    func goToAbout()
    
    func loadMoreData()
}

@Observable
final class TaskViewModel: TaskViewModelProtocol {

    var backend: BackendInteractor
    var router: TaskManagerAppRouterInteractor
    
    init(
        backend: BackendInteractor = BackendService.shared,
        router: TaskManagerAppRouterInteractor = TaskManagerAppRouter.shared
    )
    {
        self.backend = backend
        self.router = router
    }
        
    var tasks: [TaskModel] = []
    var filters: FilterParameters = FilterParameters()
    var tasksPagination: GetTasksResponse.Metadata?
    var hasMoreTasks: Bool { tasksPagination?.nextOffset != nil }
    
    var showEmptyMessage: Bool { tasks.isEmpty }
    
    var isLoading: Bool = false
    var errorMessage: String?
    var errors: Error?
    var showErrorAlert: Bool = false
    
    var colorfilterAllTasks: Color {
        filters.completed == nil ? .blue : .white
    }
    var colorfilterCompletedTasks: Color {
        filters.completed == true ? .green : .white
    }
    var colorfilterIncompletedTasks: Color {
        filters.completed == false ? .orange : .white
    }
    
    var showPopup : Bool = false
    var showPopup2 : Bool = false
    
    private var debounceTimer: AnyCancellable?
    private var debounceTask: Task<Void, Never>?
    var searchText: String = ""
//    {
//        didSet {
//            updateSearchText(searchText)
//        }
//    }

    var debouncedText: String = "" {
        didSet {
            // onSearch(debouncedText)
        }
    }
    
    func updateSearchText(with newText: String?) {
        if let newText = newText { searchText = newText }
        debounceTask?.cancel() // Cancelamos cualquier tarea previa
        debounceTask = Task { [weak self] in
            try? await Task.sleep(nanoseconds: 500_000_000) // Espera 0.5 segundos
            guard !Task.isCancelled, let self = self else { return }
            self.debouncedText = self.searchText
        }
    }
    
    func loadTasks(_ filters: FilterParameters = FilterParameters()) {
        Task {
            self.filters = filters
            isLoading = true
            do {
                let result = try await backend.getTasks(filters: filters)
                tasks = result.tasks
                tasksPagination = result.metadata
            } catch {
                print(">>> loadTasks Error: \(error.localizedDescription)", error)
                errorMessage = "No se pudo cargar las tareas, por favor intenta de nuevo"
                showErrorAlert = true
            }
            isLoading = false
        }
    }
    
    func loadMoreData() {
        
    }
    
    func retryLoadTasks() {
        loadTasks(filters)
    }
    
    func filterByState(_ state: Bool? = nil) {
        filters.completed = state
        loadTasks(filters)
    }
    
    func goToAddTask() {
        self.router.navigateTo(.TaskDetails(task: nil))
    }
    
    func goToEditTask(_ task: TaskModel) {
        self.router.navigateTo(.TaskDetails(task: task))
    }
        
    func deleteTask(_ taskId: String) {
        Task {
            do {
                try await backend.deleteTask(id: taskId)
                withAnimation {
                    tasks.removeAll { $0.id == taskId }
                }
            } catch {
                print(">>> deleteTask Error: \(error.localizedDescription)", error)
                errorMessage = "No se pudo eliminar la tarea, por favor intenta de nuevo"
                showErrorAlert = true
            }
        }
    }

    func goToProfile() {
        
    }
    
    func goToAbout() {
        
    }
}
