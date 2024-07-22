//
//  RootViewBridge.swift
//  Netflix Clone
//
//  Created by Wei Chu on 2024/7/21.
//

import Foundation
import SwiftUI

class RootViewBridge {
    func getHomeView(delegate: HomeViewModelDelegate) -> UIViewController {
        return UIHostingController(
            rootView:
                HomeView(viewModel: .init(delegate: delegate))
        )
    }
}
