//
//  TabBarViewController.swift
//  Netflix Clone
//
//  Created by Wei Chu on 2024/7/21.
//

import Foundation
import UIKit

class TabBarViewController: UIViewController {
    /// View Controller Type
    enum ViewControllerPage: Int {
        case Home
        case Upcoming
        case Search
        case Download
    }
        
    // MARK: - Model
    
    private let tabBarItemModel = [
        TabBarItemModel(icon: "house", title: "Home"),
        TabBarItemModel(icon: "play.circle", title: "Coming"),
        TabBarItemModel(icon: "magnifyingglass.circle.fill", title: "Search"),
        TabBarItemModel(icon: "arrow.down.to.line", title: "Download")
    ]
    
    // MARK: - Properties
    
    private var currentIndex = 0
    private let bottomStackHeight: CGFloat = 80

    // MARK: - UIElements
    
    private lazy var homeViewController = UINavigationController(rootViewController: HomeViewController())
    private let upcomingViewController = UINavigationController(rootViewController: UpcomingViewController())
    private let searchViewController = UINavigationController(rootViewController: SearchViewController())
    private let downloadViewController = UINavigationController(rootViewController: DownloadViewController())
    private let bottomStack = UIStackView()
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupChildViews()
        updateChildViews(pageIndex: ViewControllerPage(rawValue: currentIndex) ?? .Home)
    }
    
    // MARK: - Setup View
    
    private func setupChildViews() {
        view.backgroundColor = .white
        view.addSubview(homeViewController.view)
        homeViewController.didMove(toParent: self)
        createItem()
        setupBottomStack()
    }
    
    private func createItem() {
        tabBarItemModel.forEach { model in
            let item = TabBarItemView(image: model.icon, title: model.title)
            item.isSelected = false
            item.delegate = self
            bottomStack.addArrangedSubview(item)
        }
        
        let itemView = bottomStack.arrangedSubviews[currentIndex] as! TabBarItemView
        itemView.isSelected = true
    }
    
    private func setupBottomStack() {
        bottomStack.backgroundColor = .black.withAlphaComponent(0.9)
        bottomStack.axis = .horizontal
        bottomStack.distribution = .fillEqually
        bottomStack.spacing = 0
        bottomStackLayout()
    }
    
    private func bottomStackLayout() {
        view.addSubview(bottomStack)
        
        bottomStack.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(bottomStackHeight)
        }
    }
    
    private func updateChildViews(pageIndex: ViewControllerPage) {
        switch pageIndex {
        case .Home:
            setupNavigationStyle(title: "Movie Trailer", preferLargeTitle: false, background: .black)
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "person.circle.fill"), style: .plain, target: self, action: #selector(showProfile))
            viewLayout(view: homeViewController.view)
            
        case .Upcoming:
            setupNavigationStyle(title: "Coming Soon", preferLargeTitle: false, background: .black)
            navigationItem.rightBarButtonItem = nil

            viewLayout(view: upcomingViewController.view)

        case .Search:
            setupNavigationStyle(title: "Search", preferLargeTitle: false, background: .black)
            navigationItem.rightBarButtonItem = nil
            viewLayout(view: searchViewController.view)

        case .Download:
            setupNavigationStyle(title: "Download", preferLargeTitle: false, background: .black)
            navigationItem.rightBarButtonItem = nil
            viewLayout(view: downloadViewController.view)
        }
    }
    
    // MARK: - Methods

    /// Tab Item Animate
    /// - Parameter view: 被點擊的 Tab Item
    private func tabItemAnimate(_ view: TabBarItemView) {
        UIView.animate(withDuration: 0.2) {
            let transformSize = CGAffineTransform(scaleX: 2, y: 2)
            view.transform = transformSize
            
            let originalSize = CGAffineTransform(scaleX: 1, y: 1)
            view.transform = originalSize
        }
    }

    /// View Controller's view autolayout setting
    private func viewLayout(view: UIView) {
        view.snp.makeConstraints { make in
            make.left.right.top.equalTo(self.view)
            make.bottom.equalTo(bottomStack.snp.top)
        }
    }
    
    // MARK: - Event
    
    @objc
    func showProfile() {
        print("show profile...")
    }
}

// MARK: - TabBarItemViewDelegate

extension TabBarViewController: TabBarItemViewDelegate {
    func tapHandler(_ view: TabBarItemView) {
        let allView = bottomStack.arrangedSubviews[currentIndex] as! TabBarItemView
        allView.isSelected = false
        view.isSelected = true
        currentIndex = bottomStack.arrangedSubviews.firstIndex(where: { $0 == view }) ?? 0
        setCurrentVC(pageIndex: ViewControllerPage(rawValue: currentIndex) ?? .Home)
        tabItemAnimate(view)
    }
    
    /// Change ViewControllers
    /// - Parameter pageIndex: view controllers page index
    private func setCurrentVC(pageIndex: ViewControllerPage) {
        view.subviews.forEach { $0.removeFromSuperview() }
        setupBottomStack()
        
        switch pageIndex {
        case .Home:
            view.addSubview(homeViewController.view)
            searchViewController.didMove(toParent: self)
            
        case .Upcoming:
            view.addSubview(upcomingViewController.view)
            searchViewController.didMove(toParent: self)
            
        case .Search:
            view.addSubview(searchViewController.view)
            searchViewController.didMove(toParent: self)
            
        case .Download:
            view.addSubview(downloadViewController.view)
            searchViewController.didMove(toParent: self)
        }
        updateChildViews(pageIndex: ViewControllerPage(rawValue: currentIndex) ?? .Home)
    }
}
