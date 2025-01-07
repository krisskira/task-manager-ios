//
//  LoginModel.swift
//  task-manager
//
//  Created by Crhistian David Vergara Gomez on 4/01/25.
//

struct TokenResponseModel: Codable, Hashable {
    let token: String?
    let message: String?
}

struct RegisterModel: Encodable {
    let firstName: String
    let lastName: String
    let email: String
    let password: String
}

struct UserUpdateModel: Codable {
    let firstName: String?
    let lastName: String?
    let email: String?
    let password: String?

    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(password, forKey: .password)
        try container.encodeIfPresent(email, forKey: .email)
        try container.encodeIfPresent(firstName, forKey: .firstName)
        try container.encodeIfPresent(lastName, forKey: .lastName)
    }
    
    private enum CodingKeys: String, CodingKey {
        case email
        case password
        case firstName
        case lastName
    }
}

struct ForgotPasswordModel: Codable {
    let email: String
}

struct ForgotPasswordResponseModel: Codable {
    var message: APIMessage = .passwordReset
}

struct CreateTaskModel: Encodable {
    let title: String
    let description: String
}

struct TaskUpdateModel: Encodable {
    var title: String
    var description: String
    var completed: Bool
}

struct GetTasksResponse: Decodable {
    struct Metadata: Decodable {
        let total: Int
        let nextOffset: Int
        let previousOffset: Int
        let nextLimit: Int
        let previousLimit: Int
    }
    
    let tasks: [TaskModel]
    let metadata: Metadata
    
    enum CodingKeys: String, CodingKey {
        case tasks = "todos"
        case metadata = "metadata"
    }
}

struct FilterParameters: CustomStringConvertible {
    enum Sort: String {
        case createdAt_asc = "createdAt_asc"
        case createdAt_desc = "createdAt_desc"
        case title_asc = "title_asc"
        case title_desc = "title_desc"
        case completed_asc = "completed_asc"
        case completed_desc = "completed_desc"
    }
    
    var query: String?
    var completed: Bool?
    var sort: Sort?
    var offset: Int = 0
    var limit: Int = 20
    
    var description: String {
        var components = [String]()
        components.append("offset=\(offset)")
        components.append("limit=\(limit)")
        
        if let query = query {
            components.append("query=\(query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? query)")
        }
        if let completed = completed {
            components.append("completed=\(completed ? "true" : "false")")
        }
        if let sort = sort {
            components.append("sort=\(sort.rawValue.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? sort.rawValue)")
        }
        
        return components.joined(separator: "&")
    }
    
    func asDictionary() -> [String: Any] {
        var dict: [String: Any] = [:]
        
        dict["offset"] = offset
        dict["limit"] = limit
        
        if let query = query {
            dict["query"] = query
        }
        if let completed = completed {
            dict["completed"] = completed
        }
        if let sort = sort {
            dict["sort"] = sort.rawValue
        }
        
        return dict
    }
}

struct UserReponseModel: Codable {
    let message: String
    let data: UserModel
}

// Enum para representar los mensajes
enum APIMessage: String, Codable {
    case validationError = "validation_error"
    case userAlreadyExists = "user_already_exists"
    case userCreated = "user_created"
    case userNotFound = "user_not_found"
    case passwordReset = "password_reset"
}

// Modelo principal con genéricos para el campo `data`
struct APIResponse<T: Decodable>: Decodable {
    let message: APIMessage
    let data: T
}

// Enum que maneja automáticamente los diferentes tipos posibles de `data`
enum APIData: Decodable {
    case array([String])
    case dictionary([String: String])
    case string(String)
    
    // Decodificación automática basada en el tipo de datos
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        if let array = try? container.decode([String].self) {
            self = .array(array)
        } else if let dictionary = try? container.decode([String: String].self) {
            self = .dictionary(dictionary)
        } else if let string = try? container.decode(String.self) {
            self = .string(string)
        } else {
            throw DecodingError.typeMismatch(
                APIData.self,
                DecodingError.Context(
                    codingPath: decoder.codingPath,
                    debugDescription: "El tipo de datos en 'data' no coincide con ningún formato esperado."
                )
            )
        }
    }
}
