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
        bridgeSwiftUIView(UpcomingView(viewModel: .init(delegate: self)))
    }
}

// MARK: - UpcomingViewModelDelegate

extension UpcomingViewController: UpcomingViewModelDelegate {
    func pushYoutubeWebView(movie: Movie) {
        let vm: YoutubeWebViewModel = .init(
            movie: movie
        )
        let vc = YoutubeWebViewController(viewModel: vm)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func showErrorMessage(error: String) {
        showAlert(message: error)
    }
}

#Preview {
    return UpcomingViewController()
}
