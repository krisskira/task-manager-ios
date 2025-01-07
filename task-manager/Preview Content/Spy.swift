//
//  Spy.swift
//  task-manager
//
//  Created by Crhistian David Vergara Gomez on 6/01/25.
//

struct SpyCallTests {
    var shouldThrowError: Bool = false
    var errorToThrow: Error? = nil
    var funcCalled: [String: Any] = [:]
    mutating func spyCall<T>(_ funcName: String, _ funcParams: T) -> T {
        funcCalled[funcName] = funcParams
        return funcParams
    }
    func isCalled(key: String) -> Bool {
        return self.funcCalled.keys.contains(key)
    }
    mutating func clearCalled () {
        funcCalled.removeAll()
    }
}

protocol SpyFunction {
    var called: SpyCallTests { get }
}
