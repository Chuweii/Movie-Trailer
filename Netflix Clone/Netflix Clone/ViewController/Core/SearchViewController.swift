//
//  SearchViewController.swift
//  Netflix Clone
//
//  Created by Wei Chu on 2022/9/23.
//

import UIKit

class SearchViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        bridgeSwiftUIView(SearchView(viewModel: .init(delegate: self)))
    }
}

// MARK: - SearchViewModelDelegate

extension SearchViewController: SearchViewModelDelegate {
    func pushYoutubeWebView(title: Title) {
        let vm: YoutubeWebViewModel = .init(
            title: title
        )
        let vc = YoutubeWebViewController(viewModel: vm)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func showErrorMessage(error: String) {
        showAlert(message: error)
    }
}
