//
//  forgotViewModelTests.swift
//  task-manager
//
//  Created by Crhistian David Vergara Gomez on 6/01/25.
//


import XCTest
@testable import task_manager

final class ForgotViewModelTests: XCTestCase {
    var viewModel: ForgotViewModel!
    var backendMock: BackendServiceTest!

    override func setUp() {
        super.setUp()
        backendMock = BackendServiceTest()
        viewModel = ForgotViewModel(backend: backendMock)
    }
    
    override func tearDown() {
        backendMock = nil
        viewModel = nil
        super.tearDown()
    }

    func testOnRecoverPasswordWithEmptyEmail() {
        // Arrange
        viewModel.email = ""
        
        // Act
        viewModel.onRecoverPassword()
        
        // Assert
        XCTAssertEqual(viewModel.errorMessage, "Email es requerido")
        XCTAssertTrue(viewModel.showErrorMessage)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertFalse(viewModel.showAlert)
    }

    func testOnRecoverPasswordSuccess() async {
        // Arrange
        viewModel.email = "test@example.com"
        
        // Act
        viewModel.onRecoverPassword()
        await waitForAsyncTasks()
        
        // Assert
        XCTAssertNil(viewModel.errorMessage)
        XCTAssertFalse(viewModel.showErrorMessage)
        XCTAssertTrue(viewModel.showAlert)
        XCTAssertEqual(viewModel.alertMessage, "Se ha enviado un correo con las instrucciones para recuperar la contraseña")
        XCTAssertTrue(backendMock.called.isCalled(key: "forgotPassword"))
    }
    
    func testOnRecoverPasswordFailure() async {
        // Arrange
        viewModel.email = "test@example.com"
        backendMock.called.shouldThrowError = true
        backendMock.called.errorToThrow = NSError(domain: "test_error", code: 500)
        
        // Act
        viewModel.onRecoverPassword()
        await waitForAsyncTasks()
        
        // Assert
        XCTAssertEqual(viewModel.errorMessage, "test_error")
        XCTAssertTrue(viewModel.showErrorMessage)
        XCTAssertFalse(viewModel.showAlert)
        XCTAssertTrue(backendMock.called.isCalled(key: "forgotPassword"))
    }
}
