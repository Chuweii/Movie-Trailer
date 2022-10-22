//
//  UpcomingViewController.swift
//  Netflix Clone
//
//  Created by Wei Chu on 2022/9/23.
//

import UIKit

class UpcomingViewController: UIViewController {
    
    //create object
    private var titles = [Title]()
    
    private let upcomingTable:UITableView = {
        let table = UITableView()
        table.register(UpcomingTitleTableViewCell.self, forCellReuseIdentifier: UpcomingTitleTableViewCell.identifier)
        
        return table
    }()
    //
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        title = "Coming Soon"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.tintColor = .white
        
        view.addSubview(upcomingTable)
        upcomingTable.dataSource = self
        upcomingTable.delegate = self
        
        fetchUpcomingData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        upcomingTable.frame = view.bounds
    }
    
    //fetch api data
    private func fetchUpcomingData(){
        APICaller.shared.getUpcomingMovie { [weak self] result in
            guard let self = self else{return}
            
            switch result{
            case .success(let titles):
                self.titles = titles
                DispatchQueue.main.async {
                    self.upcomingTable.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    //
}

//upcoming tabelview
extension UpcomingViewController:UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = upcomingTable.dequeueReusableCell(withIdentifier: UpcomingTitleTableViewCell.identifier, for: indexPath) as? UpcomingTitleTableViewCell else {
            return UITableViewCell()
        }
        
        let title = titles[indexPath.row]
        let model = UpcomingTableViewCellViewModel(titleLabel: title.original_title ?? "unknow title" , titleImage: title.poster_path ?? "unknow")
        cell.configure(with: model)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        upcomingTable.deselectRow(at: indexPath, animated: true)
        
        let title = titles[indexPath.row]
        guard let titleName = title.original_title ?? title.original_name else {return}
        APICaller.shared.getYoutubeMovie(query: titleName + " trailer ") { [weak self] result in
            guard let self = self else{return}
            switch result {
            case .success(let videoElement):
                DispatchQueue.main.async {
                    let vc = TitlePreviewViewController()
                    vc.configure(with: TitlePreviewViewModel(title: titleName, youtubeView: videoElement, titleOverview: title.overview ?? ""))
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
}
