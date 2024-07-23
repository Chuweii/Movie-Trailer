//
//  BaseViewController.swift
//  Netflix Clone
//
//  Created by Wei Chu on 2024/7/23.
//

import Foundation
import UIKit

class BaseViewController: UIViewController {
    // MARK: - Properties
    
    private var isShowBackButton: Bool = false
    private let backgroundColor: UIColor = .init(red: 0.1, green: 0.1, blue: 0.1, alpha: 0.8)
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupView()
        autolayout()
    }
    
    // MARK: - Setup view
    
    private func setupView() {
        if #available(iOS 13.0, *) {
            let statusbarView = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: statusBarHeight))
            statusbarView.backgroundColor = backgroundColor
            view.addSubview(statusbarView)
        } else {
            let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView
            statusBar?.backgroundColor = backgroundColor
        }
        view.backgroundColor = .white
        view.addSubview(navigationView)
        navigationView.addSubview(backButton)
        navigationView.addSubview(titleLabel)
    }

    private func autolayout() {
        let buttonSize: CGFloat = 30
        let navigationViewHeight: CGFloat = 40

        navigationView.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top).offset(statusBarHeight)
            make.left.right.equalToSuperview()
            make.height.equalTo(navigationViewHeight)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }

        backButton.snp.makeConstraints { make in
            make.left.equalTo(navigationView.snp.left).offset(5)
            make.centerY.equalToSuperview()
            make.size.equalTo(buttonSize)
        }
    }
    
    // MARK: - Methods
    
    public func setTitle(_ title: String) {
        titleLabel.text = title
    }
    
    public func isShowBackButton(_ isShow: Bool) {
        isShowBackButton = isShow
    }
    
    @objc private func backAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Subviews
    
    lazy var navigationView: UIView = {
        let nav: UIView = .init()
        nav.backgroundColor = backgroundColor
        return nav
    }()
    
    private lazy var titleLabel: UILabel = {
        let label: UILabel = .init()
        label.font = .systemFont(ofSize: 22)
        label.textColor = .white
        label.sizeToFit()
        label.text = ""
        return label
    }()

    private lazy var backButton: UIButton = {
        let btn: UIButton = .init(type: .system)
        btn.tintColor = .white
        btn.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        btn.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        btn.isHidden = !isShowBackButton
        return btn
    }()
}

#Preview {
    BaseViewController()
}
