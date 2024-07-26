//
//  UIViewController+.swift
//  Netflix Clone
//
//  Created by Wei Chu on 2024/7/22.
//

import Foundation
import UIKit
import SwiftUI

extension UIViewController {
    // MARK: - Properties
    
    var statusBarHeight: CGFloat {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let statusBarHeight = windowScene.statusBarManager?.statusBarFrame.size.height else { return 0 }
        return statusBarHeight
    }
    
    var toScreenTopHeight: CGFloat {
        return statusBarHeight  + (navigationController?.navigationBar.frame.height ?? 0.0)
    }
    
    var safeAreaTopPadding: CGFloat {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let mainWindow = windowScene.windows.first else { return 0 }
        let topPadding = mainWindow.safeAreaInsets.top
        return topPadding
    }
    
    var safeAreaBottomPadding: CGFloat {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let mainWindow = windowScene.windows.first else { return 0 }
        let bottomPadding = mainWindow.safeAreaInsets.bottom
        return bottomPadding
    }
    
    // MARK: - Methods
    
    func bridgeSwiftUIView(_ swiftUIView: some View) {
        let hostingController = UIHostingController(rootView: swiftUIView)
        addChild(hostingController)
        view.addSubview(hostingController.view)
        hostingController.view.frame = view.bounds
        hostingController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        hostingController.didMove(toParent: self)
    }
    
    /// Show Custom Alert View
    /// - Parameters:
    ///   - message: alert message
    ///   - title: alert title
    func showAlert(title: String? = nil, message: String) {
        DispatchQueue.main.async { [weak self] in
            let alertView = CustomAlert(type: .alert, title: title, message: message)
            alertView.alpha = 0
            
            self?.view.addSubview(alertView)
            alertView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            
            UIView.animate(withDuration: 0.5) {
                alertView.alpha = 1
            }
        }
    }
    
    /// Show Custom Toast View
    /// - Parameter message: toast message
    func showToast(message: String) {
        DispatchQueue.main.async { [weak self] in
            let toastView = CustomAlert(type: .toast, message: message) { view in
                view.dismissWithAnimate(withDuration: 0.3)
            }
            toastView.alpha = 0
            
            self?.view.addSubview(toastView)
            toastView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            
            UIView.animate(withDuration: 0.3) {
                toastView.alpha = 1
            }
        }
    }
}
