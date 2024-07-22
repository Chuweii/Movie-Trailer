//
//  HomeViewController.swift
//  Netflix Clone
//
//  Created by Wei Chu on 2022/9/23.
//

import UIKit

enum Sections:Int{
    case TrendingMovies = 0
    case TrendingTv = 1
    case Popular = 2
    case Upcoming = 3
    case TopRated = 4
}

class HomeViewController: UIViewController {
    
    //tableview section title
    let sectionTitle:[String] = ["Trending Movies","Popular","Trending TV","UpComing Movies","Top Rated"]
    //
    
    private var randomHeaderView:Title?
    private var headerView:HeroHeaderUIView?
    
    private let homeFeedTable:UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(CollectionViewTableViewCell.self, forCellReuseIdentifier: CollectionViewTableViewCell.identifier)
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
//        self.setupRootView(RootViewBridge().getHomeView(delegate: self))
        
        view.backgroundColor = .systemBackground
        
        view.addSubview(homeFeedTable)
        homeFeedTable.dataSource = self
        homeFeedTable.delegate = self
        
        configureNavbar()
        
        headerView = HeroHeaderUIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 450))
        homeFeedTable.tableHeaderView = headerView

        configureHeaderView()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        homeFeedTable.frame = view.bounds
    }

}

// MARK: - HomeViewModelDelegate

extension HomeViewController: HomeViewModelDelegate {
    func showErrorMessage(error: String) {
        print(error)
    }
}

//定義navigation bar上的物件
extension HomeViewController{
        
    private func configureNavbar(){
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Movie Trailer", style: .done, target: self, action: nil)
        
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "person"), style: .done, target: self, action: nil),
            UIBarButtonItem(image: UIImage(systemName: "play.rectangle"), style: .done, target: self, action: nil)
            
        ]
        navigationController?.navigationBar.tintColor = .white
    }
}

//random headerviewimage
extension HomeViewController{
    
    private func configureHeaderView(){
        APICaller.shared.getTrendingMovies { [weak self] result in
            
            switch result {
            case .success(let titles):
                guard let self = self else{return}

                //把整包title資料,random後存入全域變數randomHeaderView上
                let selectedTitle = titles.randomElement()
                self.randomHeaderView = selectedTitle
                
                //呼叫headerView的configure方法 把資料render上
                self.headerView?.configure(with: UpcomingTableViewCellViewModel(titleLabel:selectedTitle?.original_title ?? "" , titleImage: selectedTitle?.poster_path ?? ""))
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}


extension HomeViewController:UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitle.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    //set sectiontilte textlabel
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitle[section]
    }
    
    //set sectiontitle style
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else {return}
        
        header.textLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        header.textLabel?.frame = CGRect(x: 0, y: 0, width: 100, height: header.bounds.height)
        header.textLabel?.textColor = .white
        //讓section tilte英文轉換成小寫
//        header.textLabel?.text = header.textLabel?.text?.lowercased()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = homeFeedTable.dequeueReusableCell(withIdentifier: CollectionViewTableViewCell.identifier, for: indexPath) as? CollectionViewTableViewCell else{
            return UITableViewCell()
        }
        
        cell.delegate = self
        
        switch indexPath.section {
        case Sections.TrendingMovies.rawValue:
            
            APICaller.shared.getTrendingMovies { result in
                switch result{
                case .success(let titles):
                    cell.configure(with: titles)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            
        case Sections.TrendingTv.rawValue:
            
            APICaller.shared.getTrendingTv { result in
                switch result{
                case .success(let titles):
                    cell.configure(with: titles)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            
        case Sections.Popular.rawValue:
            
            APICaller.shared.getPopular { result in
                switch result{
                case .success(let titles):
                    cell.configure(with: titles)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            
        case Sections.Upcoming.rawValue:
            
            APICaller.shared.getUpcomingMovie { result in
                switch result{
                case .success(let titles):
                    cell.configure(with: titles)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            
        case Sections.TopRated.rawValue:
            
            APICaller.shared.getToprated { result in
                switch result{
                case .success(let titles):
                    cell.configure(with: titles)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            
        default:
            return UITableViewCell()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    //pull down to hide navigation bar
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let defaultOffset = view.safeAreaInsets.top
        let offset = scrollView.contentOffset.y + defaultOffset
        
        navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0, -offset))
    }
    //
}

extension HomeViewController:CollectionViewTableViewCellDelegate{
    func colectionviewCellDidTapCell(viewModel: TitlePreviewViewModel) {
        DispatchQueue.main.async {
            let vc = YoutubeWebViewController()
            vc.configure(with: viewModel)
            vc.navigationController?.navigationBar.isHidden = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
