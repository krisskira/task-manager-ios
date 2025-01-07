//
//  BackendInteractor.swift
//  task-manager
//
//  Created by Crhistian David Vergara Gomez on 4/01/25.
//
import Foundation
import Alamofire
import KeychainAccess


protocol BackendInteractor {
    var isLoggedIn: Bool { get }
    func register(data: RegisterModel) async throws -> Void
    func login(email: String, password: String) async throws -> TokenResponseModel
    func forgotPassword(email: String) async throws -> Void
    func logout() async throws -> Void

    func getUser() async throws -> UserReponseModel
    func updateUser(data: UserUpdateModel) async throws -> Void
    
    func getTasks(filters: FilterParameters) async throws -> GetTasksResponse
    func createTask(data: CreateTaskModel) async throws -> TaskModel
    func updateTask(id: String, data: TaskUpdateModel) async throws -> Void
    func deleteTask(id: String) async throws -> Void
}

@Observable
final class BackendService: BackendInteractor {

    private let BaseURL: String = "https://todo-app-quhn.onrender.com"
    private var token: String? {
        set {
            let appId = Bundle.main.bundleIdentifier ?? "com.krisskira.task-manager"
            let keychain = Keychain(service: appId)
            keychain["token"] = newValue
        }
        get {
            let appId = Bundle.main.bundleIdentifier ?? "com.krisskira.task-manager"
            let keychain = Keychain(service: appId)
                .label("token")
                .comment("app access token")
            return try? keychain.getString("token")
        }
    }
    var isLoggedIn: Bool { token != nil }

    static let shared = BackendService()
    
    func register(data: RegisterModel) async throws -> Void {
        let request = AF.request(
            "\(BaseURL)/api/v1/security/register",
            method: .post,
            parameters: data,
            encoder: JSONParameterEncoder.default
        )
        let response = request.serializingDecodable(APIResponse<APIData>.self)
        guard let value = try? await response.value else {
            throw NSError(domain: "No se pudo procesar la petición", code: 0)
        }
        switch value.message {
        case .userCreated:
            return
        case .userAlreadyExists:
            throw NSError(
                domain: "El usuario ya existe",
                code: 1,
                userInfo: [
                    NSLocalizedDescriptionKey: [value.message.rawValue],
                    "errors": [value.message.rawValue]
                ])
        case .validationError:
            switch value.data {
            case .array(let errors):
                throw NSError(
                    domain: "Error de validación",
                    code: 1,
                    userInfo: [
                        NSLocalizedDescriptionKey: errors,
                        "errors": errors
                    ])
            default:
                throw NSError(domain: "Error de validación", code: 1)
            }
        default:
            throw NSError(domain: "No se pudo procesar la petición", code: 0)
        }
    }
    
    func login(email: String, password: String) async throws -> TokenResponseModel {
        let data = "\(email):\(password)".data(using: .utf8)?.base64EncodedString()
        
        let request = AF.request(
            "\(BaseURL)/api/v1/security/login",
            method: .get,
            headers: ["authorization": "Basic \(data!)"]
        )
        let response = await request.serializingDecodable(TokenResponseModel.self).response
        
        guard
            response.error == nil,
            let result = response.value,
            let statusCode = response.response?.statusCode
        else {
            throw NSError(domain: "No se pudo procesar la petición", code: 0)
        }
        
        if(statusCode >= 400) {
            let message = result.message == "unauthorized"
            ? "Usuario o contraseña incorrectos"
            : result.message ?? "Error desconocido [\(statusCode): \(result.message ?? "")]"
            throw NSError(domain: message, code: statusCode)
        }
        self.token = result.token
        return result
    }
    
    func forgotPassword(email: String) async throws -> Void {
        let param = ForgotPasswordModel(email: email)
        let request = AF.request(
            "\(BaseURL)/api/v1/security/forgot-password/",
            method: .post,
            parameters: param
        )
        let response = try await request.serializingDecodable(ForgotPasswordResponseModel.self).value
        if response.message != .passwordReset {
            throw NSError(domain: "No se pudo validar el email", code: 1, userInfo: [
                NSLocalizedDescriptionKey: "No se pudo validar el email",
                "errors": [response.message.rawValue]
            ])
        }
    }
    
    func updateUser(data: UserUpdateModel) async throws -> Void {
        guard let token = self.token else { throw NSError(domain: "Must be logged", code: 0) }
        let request = AF.request(
            "\(BaseURL)/api/v1/user/",
            method: .patch,
            parameters: data,
            headers: ["authorization": "Bearer \(token)"]
        )
        let _ = try await request.serializingDecodable(APIResponse<UserUpdateModel>.self).value
    }
    
    func getUser() async throws -> UserReponseModel {
        guard let token = self.token else { throw NSError(domain: "Must be logged", code: 0) }
        let request = AF.request(
            "\(BaseURL)/api/v1/user/",
            method: .get,
            headers: ["authorization": "Bearer \(token)"]
        )
        return try await request.serializingDecodable(UserReponseModel.self).value
    }
    
    func createTask(data: CreateTaskModel) async throws -> TaskModel {
        guard let token = self.token else { throw NSError(domain: "Must be logged", code: 0) }
        let request = AF.request(
            "\(BaseURL)/api/v1/tasks/",
            method: .post,
            parameters: data,
            headers: ["authorization": "Bearer \(token)"]
        )
        return try await request.serializingDecodable(TaskModel.self).value
    }
    
    func getTasks(filters: FilterParameters) async throws -> GetTasksResponse {
        guard let token = self.token else { throw NSError(domain: "Must be logged", code: 0) }
        let parameters = filters.asDictionary()
        let request = AF.request(
            "\(BaseURL)/api/v1/tasks/",
            method: .get,
            parameters: parameters,
            headers: ["authorization": "Bearer \(token)"]
        )
        return try await request.serializingDecodable(GetTasksResponse.self).value
    }
    
    func updateTask(id: String, data: TaskUpdateModel) async throws -> Void {
        guard let token = self.token else { throw NSError(domain: "Must be logged", code: 0) }
        let request = AF.request(
            "\(BaseURL)/api/v1/tasks/\(id)/",
            method: .put,
            parameters: data,
            headers: ["authorization": "Bearer \(token)"]
        )
        let _ = try await request.serializingData().value
    }
    
    func deleteTask(id: String) async throws -> Void {
        guard let token = self.token else { throw NSError(domain: "Must be logged", code: 0) }
        let request = AF.request(
            "\(BaseURL)/api/v1/tasks/\(id)/",
            method: .delete,
            headers: ["authorization": "Bearer \(token)"]
        )
        let _ = try await request.serializingData().value
    }
    
    func logout() async throws -> Void {
        token = nil
    }
}
