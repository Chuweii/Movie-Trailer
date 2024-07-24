//
//  DownloadViewController.swift
//  Netflix Clone
//
//  Created by Wei Chu on 2022/9/23.
//

import UIKit

class DownloadViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        bridgeSwiftUIView(DownloadView(viewModel: .init(delegate: self)))
    }
}

extension DownloadViewController: DownloadViewModelDelegate {
    func showErrorMessage(error: String) {
        print(error)
    }
}

