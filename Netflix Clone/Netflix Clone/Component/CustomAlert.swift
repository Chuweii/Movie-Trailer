//
//  CustomAlert.swift
//  Netflix Clone
//
//  Created by Wei Chu on 2024/7/24.
//

import Foundation
import UIKit

class CustomAlert: UIView {
    enum AlertType: Int {
        case alert
        case toast
    }
    
    // MARK: - Public
    /// RemoveFromSuperView With Animate
    public func dismissWithAnimate(withDuration: TimeInterval) {
        UIView.animate(withDuration: withDuration) {
            self.alpha = 0
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + withDuration) {
            self.removeFromSuperview()
        }
    }
    
    // MARK: - Properties
    /// init properties
    private let type: AlertType
    private let title: String?
    private let message: String
    private var spaceHandler: ((CustomAlert) -> Void)?
    /// properties
    private let messageStackPadding: CGFloat = 20
    private lazy var tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))

    // MARK: - Init
    /// Custom AlertView
    /// - Parameters:
    ///   - type: Type of alert view
    ///   - title: Alert title
    ///   - message: Message
    ///
    /// - Warning: Only when type = alert, can set title
    init(type: AlertType, title: String? = nil, message: String, spaceHandler: ((CustomAlert) -> Void)? = nil) {
        self.type = type
        self.title = title
        self.message = message
        self.spaceHandler = spaceHandler
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    // MARK: - Setup View
    
    private func setupView() {
        subviews.forEach({ $0.removeFromSuperview() })
        self.addGestureRecognizer(tapGesture)
        
        switch type {
        case .alert:
            backgroundColor = .black.withAlphaComponent(0.3)
            configAlertView()
            alertViewLayout()
            
        case .toast:
            backgroundColor = .clear
            configToastView()
            toastViewLayout()
        }
    }
    
    // MARK: - Configuration
    
    private func configAlertView() {
        alertView.subviews.forEach({ $0.removeFromSuperview() })
        if let title = self.title, title.trimmingCharacters(in: .whitespaces).count > 0 {
            titleLabel.text = title
            messageStackView.addArrangedSubview(titleLabel)
        }
        
        messageStackView.addArrangedSubview(messageLabel)
        buttonStackView.addArrangedSubview(button)
        alertView.addSubview(messageStackView)
        alertView.addSubview(buttonStackView)
        
        messageStackView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
        }
        buttonStackView.snp.makeConstraints { make in
            make.top.equalTo(messageStackView.snp.bottom).offset(0.5)
            make.left.right.bottom.equalToSuperview()
        }
        addSubview(alertView)
    }
    
    private func configToastView() {
        toastView.subviews.forEach({ $0.removeFromSuperview() })
        messageLabel.textColor = .black
        messageStackView.distribution = .fill
        messageStackView.axis = .horizontal
        
        messageStackView.addArrangedSubview(messageLabel)
        messageStackView.addArrangedSubview(cancelButton)
        toastView.addSubview(messageStackView)
        
        messageStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        addSubview(toastView)
    }
    
    // MARK: - Autolayout
    
    private func alertViewLayout() {
        alertView.layer.cornerRadius = 20
        alertView.clipsToBounds = true
        
        alertView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.width.equalTo(self).multipliedBy(0.8)
        }
        
        button.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
    }
    
    private func toastViewLayout() {
        toastView.layer.cornerRadius = 25
        toastView.clipsToBounds = true
        
        toastView.snp.makeConstraints { make in
            make.bottom.equalTo(self.snp.bottom).offset(-50)
            make.centerX.equalToSuperview()
            make.width.equalTo(self).multipliedBy(0.7)
        }
        
        cancelButton.snp.makeConstraints { make in
            make.width.equalTo(30)
        }
    }
        
    // MARK: - Event
    
    @objc func event() {
        dismissWithAnimate(withDuration: 0.3)
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        guard let spaceHandler = spaceHandler else { return }
        spaceHandler(self)
    }
    
    // MARK: - UIElements
    
    private lazy var alertView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.sizeToFit()
        return view
    }()
    private lazy var messageStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 10
        stack.distribution = .fill
        stack.isLayoutMarginsRelativeArrangement = true
        stack.directionalLayoutMargins = NSDirectionalEdgeInsets(top: messageStackPadding, leading: messageStackPadding, bottom: messageStackPadding, trailing: messageStackPadding)
        return stack
    }()
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.sizeToFit()
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    private lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.sizeToFit()
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.text = message
        return label
    }()
    private let buttonStackView: UIStackView = {
        let stack = UIStackView()
        stack.backgroundColor = .black.withAlphaComponent(0.2)
        stack.axis = .horizontal
        stack.spacing = 1
        stack.distribution = .fillEqually
        stack.isLayoutMarginsRelativeArrangement = true
        stack.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 1, leading: 0, bottom: 0, trailing: 0)
        return stack
    }()
    private lazy var button: UIButton = {
        let btn = UIButton(type: .system)
        btn.backgroundColor = .white
        btn.setTitle("OK", for: .normal)
        btn.setTitleColor(.blue, for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        btn.addTarget(self, action: #selector(event), for: .touchUpInside)
        return btn
    }()
    private lazy var toastView: UIView = {
        let view = UIView()
        view.backgroundColor = .white.withAlphaComponent(0.7)
        view.sizeToFit()
        return view
    }()
    private lazy var cancelButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.contentMode = .scaleAspectFit
        btn.tintColor = .black
        btn.setImage(UIImage(systemName: "x.circle.fill"), for: .normal)
        btn.addTarget(self, action: #selector(event), for: .touchUpInside)
        return btn
    }()
}
