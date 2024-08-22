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
    private var cancellables: Set<AnyCancellable> = .init()

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
        setBinding()
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
    
    private func setBinding() {
        viewModel.$shouldLoadVideo
            .filter { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.loadVideo()
            }
            .store(in: &cancellables)
        
        viewModel.$errorMessage
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.showAlert(message: $0)
            }
            .store(in: &cancellables)
        
        viewModel.$shouldShowToast
            .filter { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.showToast(message: "Downloaded!! 🥳🥳 Check out on Download page.")
            }
            .store(in: &cancellables)
    }
    
    private func loadVideo() {
        webView.load(URLRequest(url: viewModel.videoURL!))
    }
    
    @objc
    private func didClickDownload() {
        Task {
            await viewModel.downloadMovie()
        }
    }
    
    private func setupView() {
        navigationController?.navigationBar.tintColor = .white
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
        let buttonSize: CGSize = .init(width: 200, height: 40)
        
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
            make.top.equalTo(overviewLabel.snp.bottom).offset(padding)
            make.bottom.equalTo(contentView).inset(padding)
            make.centerX.equalToSuperview()
            make.width.equalTo(buttonSize.width)
            make.height.equalTo(buttonSize.height)
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
        label.text = viewModel.getMovieTitle
        return label
    }()
    
    private lazy var overviewLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.numberOfLines = 0
        label.sizeToFit()
        label.text = viewModel.title.overview
        return label
    }()
    
    private let webView: WKWebView = {
        let webView = WKWebView()
        return webView
    }()
    
    private lazy var downloadButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Download", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 20)
        btn.backgroundColor = .white
        btn.layer.cornerRadius = 10
        btn.addTarget(self, action: #selector(didClickDownload), for: .touchUpInside)
        return btn
    }()
}

