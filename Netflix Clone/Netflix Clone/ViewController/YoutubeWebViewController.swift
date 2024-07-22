//
//  TitlePreviewViewController.swift
//  Netflix Clone
//
//  Created by Wei Chu on 2022/9/30.
//

import UIKit
import WebKit

class YoutubeWebViewController: UIViewController {
    var vm: YoutubeWebViewModel? = nil
    
    private lazy var scrollView: UIScrollView = {
        let sc: UIScrollView = .init()
        sc.addSubview(webView)
        sc.addSubview(titleLabel)
        sc.addSubview(overviewLabel)
        sc.addSubview(downloadButton)
        return sc
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.numberOfLines = 0
        label.sizeToFit()
        label.text = "AAA"
        return label
    }()
    
    private let overviewLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.numberOfLines = 0
        label.text = "asdljkfal;sdjf;lkajsd;flkja;sldjf;alkjsdf;lajs;dlfja;lsdkfj"
        label.sizeToFit()
        return label
    }()
    
    private let downloadButton: UIButton = {
        let button = UIButton()
        button.setTitle("Download", for: .normal)
        button.backgroundColor = .red
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        return button
    }()
    
    private let webView: WKWebView = {
        let webView = WKWebView()
        
        return webView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(webView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(overviewLabel)
        contentView.addSubview(downloadButton)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        autolayout()
    }
    
    func configure(with viewModel: TitlePreviewViewModel) {
        titleLabel.text = viewModel.title
        overviewLabel.text = viewModel.titleOverview
        
        guard let url = URL(string: "https://www.youtube.com/embed/\(viewModel.youtubeView.id.videoId)") else { return }
        webView.load(URLRequest(url: url))
    }
    
    private func autolayout() {
        let padding: CGFloat = 20
        let buttonSize: CGSize = .init(width: 120, height: 40)
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView.contentLayoutGuide)
            make.width.equalTo(scrollView.frameLayoutGuide)
        }
        
        webView.snp.makeConstraints { make in
            make.top.left.right.equalTo(contentView)
            make.height.equalTo(view.bounds.height / 3)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(webView.snp.bottom).offset(padding)
            make.left.right.equalTo(contentView).inset(padding)
        }
        
        overviewLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(padding)
            make.left.right.equalTo(contentView).inset(padding)
        }
        
        downloadButton.snp.makeConstraints { make in
            make.top.equalTo(overviewLabel.snp.bottom).offset(padding * 2)
            make.centerX.equalTo(contentView)
            make.width.equalTo(buttonSize.width)
            make.height.equalTo(buttonSize.height)
            make.bottom.equalTo(contentView).offset(-padding)
        }
    }
}

#Preview {
    YoutubeWebViewController()
}
