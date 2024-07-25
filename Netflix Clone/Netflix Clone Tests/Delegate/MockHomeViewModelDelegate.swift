//
//  MockHomeViewModelDelegate.swift
//  Netflix Clone Tests
//
//  Created by Wei Chu on 2024/7/25.
//

import Foundation
import Moya
@testable import Netflix_Clone

class MockHomeViewModelDelegate: HomeViewModelDelegate {
    var didCallPushYoutubeWebView: Bool = false
    var didCallShowErrorMessage: Bool = false
    var didCallShowToast: Bool = false

    func pushYoutubeWebView(title: Netflix_Clone.Title) {
        didCallPushYoutubeWebView = true
    }
    
    func showErrorMessage(error: String) {
        didCallShowErrorMessage = true
    }
    
    func showToast(_ message: String) {
        didCallShowToast = true
    }
}
