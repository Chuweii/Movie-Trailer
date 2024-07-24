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
    
    var topbarHeight: CGFloat {
        return statusBarHeight  + (navigationController?.navigationBar.frame.height ?? 0.0)
    }
    
    /// Safe area top padding
    var topPadding: CGFloat {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let mainWindow = windowScene.windows.first else { return 0 }
        let topPadding = mainWindow.safeAreaInsets.top
        return topPadding
    }
    
    /// Safe area bottom padding
    var bottomPadding: CGFloat {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let mainWindow = windowScene.windows.first else { return 0 }
        let bottomPadding = mainWindow.safeAreaInsets.bottom
        return bottomPadding
    }
    
    // MARK: - Methods
    
    func setupNavigationStyle(title: String, preferLargeTitle: Bool, background: UIColor) {
        // Title
        navigationItem.title = title
        navigationController?.navigationBar.prefersLargeTitles = preferLargeTitle
        navigationController?.navigationItem.largeTitleDisplayMode = .always

        // Navigation Background Color
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.backgroundColor = background
        
        // NavigationBar
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.overrideUserInterfaceStyle = .dark
    }
    
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
        let alertView = CustomAlert(type: .alert, title: title, message: message)
        alertView.alpha = 0
        
        view.addSubview(alertView)
        alertView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        UIView.animate(withDuration: 0.5) {
            alertView.alpha = 1
        }
    }
    
    /// Show Custom Toast View
    /// - Parameter message: toast message
    func showToast(message: String) {
        let toastView = CustomAlert(type: .toast, message: message) { view in
            view.dismissWithAnimate(withDuration: 0.3)
        }
        toastView.alpha = 0
        
        view.addSubview(toastView)
        toastView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        UIView.animate(withDuration: 0.3) {
            toastView.alpha = 1
        }
    }
}
