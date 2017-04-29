//
//  SignUpInteractorTest.swift
//  Vyrl
//
//  Created by Benjamin Hendricks on 4/29/17.
//  Copyright © 2017 Vyrl. All rights reserved.
//

@testable import Vyrl
import XCTest

final class SignUpServiceMock: UserSignUpProviding {
    var didCallService = false
    var success = true
    var result: UserProfile?
    var error: SignUpError = .unknown
    
    func signUp(using request: UserSignUpRequest, completion: @escaping (Result<UserProfile, SignUpError>) -> Void) {
        didCallService = true
        if let result = result, success {
            completion(Result.success(result))
        } else {
            completion(Result.failure(error))
        }
    }
}

final class SignUpPresenterMock: ErrorAlertPresenting, ViewActivityPresenting {
    var didPresentError = false
    var didPresentActivity = false
    var didDismissActivity = false
    
    func presentActivity() {
        didPresentActivity = true
    }
    
    func dismiss() {
        didDismissActivity = true
    }
    
    func presentError(title: String?, message: String?) {
        didPresentError = true
    }
}

final class SignUpInteractorTest: XCTestCase {
    
    private var apiService: SignUpServiceMock!
    private var presenter: SignUpPresenterMock!
    private var subject: SignUpInteractor!
    private var formItem: FormItem!
    private var listener: AuthorizationListenerMock!
    private var authNavigation: AuthorizationNavigating!
    private var apiConfiguration = APIConfigurationMock()

    
    override func setUp() {
        super.setUp()
        apiService = SignUpServiceMock()
        presenter = SignUpPresenterMock()
        listener = AuthorizationListenerMock()
        authNavigation = AuthorizationNavigationMock()
        formItem = FormItem(field: .vyrlUsername, textField: MockTextField())
        subject = SignUpInteractor(signUpService: apiService, apiConfiguration: apiConfiguration)
    }
    
}
