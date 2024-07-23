//
//  UpcomingViewController.swift
//  Netflix Clone
//
//  Created by Wei Chu on 2022/9/23.
//

import UIKit

class UpcomingViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupRootView(RootViewBridge().getUpcomingView(delegate: self))
    }
}

// MARK: - UpcomingViewModelDelegate

extension UpcomingViewController: UpcomingViewModelDelegate {
    func pushYoutubeWebView(title: Title) {
        let vm: YoutubeWebViewModel = .init(
            movieTitle: title.original_title ?? "",
            overViewText: title.overview ?? ""
        )
        let vc = YoutubeWebViewController(viewModel: vm)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func showErrorMessage(error: String) {
        printContent(error)
    }
}

#Preview {
    return UpcomingViewController()
}
