//
//  DownloadViewController.swift
//  Netflix Clone
//
//  Created by Wei Chu on 2022/9/23.
//

import UIKit

class DownloadViewController: UIViewController {
    
    private var titles:[TitleItem] = [TitleItem]()
    
    private let downloadTable:UITableView = {
        let table = UITableView()
        
        table.register(UpcomingTitleTableViewCell.self, forCellReuseIdentifier: UpcomingTitleTableViewCell.identifier)

        
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        
        title = "Downloads"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        setTableView()
        
        fetchLocalStorageForDownload()
        
        //register notification listener to update new downloaded movie
        NotificationCenter.default.addObserver(forName: NSNotification.Name("downloaded"), object: nil, queue: nil) { _ in
            self.fetchLocalStorageForDownload()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        downloadTable.frame = view.bounds
    }
    
    
    private func setTableView(){
        view.addSubview(downloadTable)
        downloadTable.dataSource = self
        downloadTable.delegate = self
    }
    
    private func fetchLocalStorageForDownload(){
        DataPersistenceManager.shared.fetchingTitleFromDataBase { [weak self] result in
            guard let self = self else {
                return
            }
            
            switch result{
            case .success(let titles):
                self.titles = titles
                
                DispatchQueue.main.async {
                    self.downloadTable.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }


}


extension DownloadViewController:UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = downloadTable.dequeueReusableCell(withIdentifier: UpcomingTitleTableViewCell.identifier, for: indexPath) as? UpcomingTitleTableViewCell else{
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
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            DataPersistenceManager.shared.deletTitleWith(model: titles[indexPath.row]) { [weak self] result in
                switch result{
                case .success():
                    print("Delet from the database.")
                case .failure(let error):
                    print(error.localizedDescription)
                }
                self?.titles.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)

            }
        default:
            break;

        }
                
    }
}
