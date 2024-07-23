//
//  SearchViewController.swift
//  Netflix Clone
//
//  Created by Wei Chu on 2022/9/23.
//

import UIKit

class SearchViewController: UIViewController {
    
    private var titles = [Title]()

    private let searchTable:UITableView = {
        let table = UITableView()
        table.register(UpcomingTitleTableViewCell.self, forCellReuseIdentifier: UpcomingTitleTableViewCell.identifier)
    
        return table
    }()
    
    private let searchController:UISearchController = {
        let  controller = UISearchController(searchResultsController: SearchResultViewController())
        controller.searchBar.placeholder = "Search for a Movie or Tv show"
        controller.searchBar.searchBarStyle = .minimal
        
        return controller
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
                
        view.addSubview(searchTable)
        searchTable.dataSource = self
        searchTable.delegate = self
        searchController.searchResultsUpdater = self
        
        fetchSearchData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        searchTable.frame = view.bounds
    }
    
    //fetch api data
    private func fetchSearchData(){
        APICaller.shared.getPopular { [weak self] result in
            guard let self = self else {return}
            
            switch result {
            case .success(let titles):
                self.titles = titles
                DispatchQueue.main.async {
                    self.searchTable.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

}


extension SearchViewController:UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = searchTable.dequeueReusableCell(withIdentifier: UpcomingTitleTableViewCell.identifier, for: indexPath) as? UpcomingTitleTableViewCell else {
            return UITableViewCell()
        }
        let title = titles[indexPath.row]
        print(title)
        let model = UpcomingTableViewCellViewModel(titleLabel: title.original_title ?? "unknown", titleImage: title.poster_path ?? "" )
        cell.configure(with: model)
    
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        searchTable.deselectRow(at: indexPath, animated: true)
        
        let title = titles[indexPath.row]
        guard let titleName = title.original_title ?? title.original_name else {return}
        
        APICaller.shared.getYoutubeMovie(query: titleName + " trailer ") { [weak self] result in
            guard let self = self else {return}
            switch result {
            case .success(let videoElement):
                DispatchQueue.main.async {
//                    let vc = YoutubeWebViewController()
//                    vc.configure(with: TitlePreviewViewModel(title: titleName, youtubeView: videoElement, titleOverview: title.overview ?? ""))
//                    self.navigationController?.pushViewController(vc, animated: true)
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
    }
    
}


extension SearchViewController:UISearchResultsUpdating, SearchResulCollectionViewDelegate{
    
    func updateSearchResults(for searchController: UISearchController) {
        
        let searchBar = searchController.searchBar
        guard let query = searchBar.text,
              !query.trimmingCharacters(in: .whitespaces).isEmpty, //自動把使用者輸入的空白trimed掉,且輸入不能為空
              query.trimmingCharacters(in: .whitespaces).count >= 3, //使用者輸入的數字至少要大於等於3位,才會開始搜索
              let searchResult = searchController.searchResultsController as? SearchResultViewController else {return}
        
        searchResult.delegate = self
        
        APICaller.shared.getSearchQuery(query: query) { result in
            DispatchQueue.main.async {
                switch result{
                case .success(let titles):
                    searchResult.titles = titles
                    searchResult.searchCollectionView.reloadData()
                case .failure(let error):
                    print(error.localizedDescription)
                }//end of result switch
            }//end of dispatchQ
        }//end of apicaller
    }
    
    
    func SearchResulCollectionViewCellDidTapItem(viewModel: TitlePreviewViewModel) {
        DispatchQueue.main.async {
//            let vc = YoutubeWebViewController()
//            vc.configure(with: TitlePreviewViewModel(title: viewModel.title, youtubeView: viewModel.youtubeView, titleOverview: viewModel.titleOverview))
//            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
