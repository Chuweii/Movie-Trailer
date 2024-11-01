//
//  HomeViewController.swift
//  Netflix Clone
//
//  Created by Wei Chu on 2022/9/23.
//

import UIKit

class HomeViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bridgeSwiftUIView(HomeView(viewModel: .init(delegate: self)))
    }
}

// MARK: - HomeViewModelDelegate

extension HomeViewController: HomeViewModelDelegate {
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
    
    func showToast(_ message: String) {
        showToast(message: message)
    }
}
