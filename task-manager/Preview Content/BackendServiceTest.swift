//
//  BackendServiceTest.swift
//  task-manager
//
//  Created by Crhistian David Vergara Gomez on 6/01/25.
//
import SwiftUI

@Observable
final class BackendServiceTest: BackendInteractor, SpyFunction {
    var called = SpyCallTests()
    
    private var token: String? = nil
    var isLoggedIn: Bool {
        get {
            ((token?.isEmpty) != nil)
        }
    }
    
    init(called: SpyCallTests = SpyCallTests(), token: String? = nil) {
        self.called = called
        self.token = token
    }
    
    func register(data: RegisterModel) async throws {
        let _ = called.spyCall("register", data)
        if(called.shouldThrowError) {
            throw called.errorToThrow ?? NSError(domain: "test_error", code: 500)
        }
    }
    
    func login(email: String, password: String) async throws -> TokenResponseModel {
        let _ = called.spyCall("login", ["email": email, "password": password])
        if(called.shouldThrowError) {
            throw called.errorToThrow ?? NSError(domain: "test_error", code: 500)
        }
        if (email.isEmpty && password.isEmpty) {
            throw NSError(domain: "error test", code: 400)
        }

        token = "token"
        return .init(token: "token", message: nil)
    }
    
    func forgotPassword(email: String) async throws {
        let _ = called.spyCall("forgotPassword", email)
        if(called.shouldThrowError) {
            throw called.errorToThrow ?? NSError(domain: "test_error", code: 500)
        }
    }
    
    func logout() async throws {
        let _ = called.spyCall("logout", [:])
        if(called.shouldThrowError) {
            throw called.errorToThrow ?? NSError(domain: "test_error", code: 500)
        }
        token = ""
    }
    
    func getUser() async throws -> UserReponseModel {
        let _ = called.spyCall("getUser", [:])
        if(called.shouldThrowError) {
            throw called.errorToThrow ?? NSError(domain: "test_error", code: 500)
        }
        if !isLoggedIn {
            throw NSError(domain: "error test", code: 400)
        }
        return .init(
            message: "get user test",
            data: UserDataTest
        )
    }
    
    func updateUser(data: UserUpdateModel) async throws {
        let _ = called.spyCall("updateUser", data)
        if(called.shouldThrowError) {
            throw called.errorToThrow ?? NSError(domain: "test_error", code: 500)
        }
        if !isLoggedIn {
            throw NSError(domain: "error test", code: 400)
        }
    }
    
    func getTasks(filters: FilterParameters) async throws -> GetTasksResponse {
        // Simular el llamado y espiar los parámetros
        let _ = called.spyCall("getTasks", filters)
        if(called.shouldThrowError) {
            throw called.errorToThrow ?? NSError(domain: "test_error", code: 500)
        }
        // Verificar si el token está vacío
        if !isLoggedIn {
            throw NSError(domain: "error test", code: 400)
        }
        
        // Aplicar filtros
        var filteredTasks = TaskDataTest
        
        if let query = filters.query, !query.isEmpty {
            filteredTasks = filteredTasks.filter {
                $0.title.localizedCaseInsensitiveContains(query) ||
                $0.description.localizedCaseInsensitiveContains(query)
            }
        }
        
        if let completed = filters.completed {
            filteredTasks = filteredTasks.filter { $0.completed == completed }
        }
        
        if let sort = filters.sort {
            switch sort {
            case .createdAt_asc:
                filteredTasks.sort { $0.createdAt < $1.createdAt }
            case .createdAt_desc:
                filteredTasks.sort { $0.createdAt > $1.createdAt }
            case .title_asc:
                filteredTasks.sort { $0.title.localizedCaseInsensitiveCompare($1.title) == .orderedAscending }
            case .title_desc:
                filteredTasks.sort { $0.title.localizedCaseInsensitiveCompare($1.title) == .orderedDescending }
            case .completed_asc:
                filteredTasks.sort { !$0.completed && $1.completed }
            case .completed_desc:
                filteredTasks.sort { $0.completed && !$1.completed }
            }
        }
        
        // Aplicar paginación
        let total = filteredTasks.count
        let offset = filters.offset
        let limit = filters.limit
        let paginatedTasks = Array(filteredTasks.dropFirst(offset).prefix(limit))
        
        // Crear metadatos
        let metadata = GetTasksResponse.Metadata(
            total: total,
            nextOffset: min(offset + limit, total),
            previousOffset: max(offset - limit, 0),
            nextLimit: limit,
            previousLimit: limit
        )
        
        // Retornar la respuesta
        return GetTasksResponse(tasks: paginatedTasks, metadata: metadata)
    }

    func createTask(data: CreateTaskModel) async throws -> TaskModel {
        let _ = called.spyCall("createTask", data)
        if(called.shouldThrowError) {
            throw called.errorToThrow ?? NSError(domain: "test_error", code: 500)
        }
        if !isLoggedIn {
            throw NSError(domain: "error test", code: 400)
        }
        let taskId = TaskDataTest.count + 1
        return TaskModel(
            id: "\(taskId)",
            title: "New task \(taskId)",
            description: "New task description (\(taskId))",
            completed: false,
            createdAt: Date()
        )
    }
    
    func updateTask(id: String, data: TaskUpdateModel) async throws {
        let _ = called.spyCall("updateTask", ["id":id, "data":data])
        if(called.shouldThrowError) {
            throw called.errorToThrow ?? NSError(domain: "test_error", code: 500)
        }
        if !isLoggedIn {
            throw NSError(domain: "error test", code: 400)
        }
    }
    
    func deleteTask(id: String) async throws {
        let _ = called.spyCall("deleteTask", ["id":id])
        if(called.shouldThrowError) {
            throw called.errorToThrow ?? NSError(domain: "test_error", code: 500)
        }
        if !isLoggedIn {
            throw NSError(domain: "error test", code: 400)
        }
    }
    
    func performDelay(seconds: Double = 2.0) async {
        try? await Task.sleep(nanoseconds: UInt64(seconds * 1_000_000_000))
    }
}
