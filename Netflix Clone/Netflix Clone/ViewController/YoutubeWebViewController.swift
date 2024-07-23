//
//  TitlePreviewViewController.swift
//  Netflix Clone
//
//  Created by Wei Chu on 2022/9/30.
//

import UIKit
import WebKit
import Combine

class YoutubeWebViewController: UIViewController {
    // MARK: - Properties
    
    let viewModel: YoutubeWebViewModel
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Init

    init(viewModel: YoutubeWebViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupBindings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        Task {
            await viewModel.getYoutubeMovie()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        autolayout()
    }
    
    // MARK: - Methods
    
    private func setupBindings() {
        viewModel.$shouldLoadVideo
            .filter { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.loadVideo()
            }
            .store(in: &cancellables)
    }
    
    private func loadVideo() {
        guard let videoId = viewModel.video?.id.videoId, let url = URL(string: .youtubeURLPath(videoId: videoId)) else { return }
        webView.load(URLRequest(url: url))
    }
    
    private func setupView() {
        view.backgroundColor = .black
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(webView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(overviewLabel)
        contentView.addSubview(downloadButton)
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
    
    // MARK: - Subviews
    
    private lazy var scrollView: UIScrollView = .init()
    
    private let contentView: UIView = .init()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.numberOfLines = 0
        label.sizeToFit()
        label.text = viewModel.movieTitle
        return label
    }()
    
    private lazy var overviewLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.numberOfLines = 0
        label.sizeToFit()
        label.text = viewModel.overViewText
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
}

