//
//  UIViewController+.swift
//  Netflix Clone
//
//  Created by Wei Chu on 2024/7/22.
//

import Foundation
import UIKit

extension UIViewController {
    
    // MARK: - Properties
    
    var topbarHeight: CGFloat {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let statusBarHeight = windowScene.statusBarManager?.statusBarFrame.size.height else { return 0 }
        return statusBarHeight  + (self.navigationController?.navigationBar.frame.height ?? 0.0)
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
    
    func setupNavigationStyle(title: String, preferLargeTitle: Bool , background: UIColor) {
        /// Title
        self.navigationItem.title = title
        self.navigationController?.navigationBar.prefersLargeTitles = preferLargeTitle
        self.navigationController?.navigationItem.largeTitleDisplayMode = .always

        /// Navigation Background Color
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.backgroundColor = background
        
        /// NavigationBar
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.standardAppearance = appearance
        self.navigationController?.navigationBar.compactAppearance = appearance
        self.navigationController?.navigationBar.scrollEdgeAppearance = appearance
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.overrideUserInterfaceStyle = .dark
    }
    
    func setupRootView(_ vc: UIViewController) {
        self.view.addSubview(vc.view)
        vc.view.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.bottom.left.right.equalToSuperview()
        }
    }
}
