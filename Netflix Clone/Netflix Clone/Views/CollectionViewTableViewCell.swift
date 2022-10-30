//
//  CollectionViewTableViewCell.swift
//  Netflix Clone
//
//  Created by Wei Chu on 2022/9/23.
//

import UIKit

protocol CollectionViewTableViewCellDelegate :AnyObject{
    func colectionviewCellDidTapCell(viewModel:TitlePreviewViewModel)
}

class CollectionViewTableViewCell: UITableViewCell {
    
    static let identifier = "CollectionViewTableViewCell"
    
    weak var delegate:CollectionViewTableViewCellDelegate?
    
    private var titles = [Title]()
    
    private let collectionView:UICollectionView = {
       
        let layout = UICollectionViewFlowLayout()
        //collectionview中的捲動方向
        layout.scrollDirection = .horizontal
        
        layout.itemSize = CGSize(width: 140, height: 200)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: TitleCollectionViewCell.identifier)
        
        return collectionView
    }()
    
    
    //用code設計cell必用的兩個方法
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = .systemPink
        contentView.addSubview(collectionView)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    //
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = contentView.bounds
    }
    
    //MARK: configure collectionview cell's component
    public func configure(with titles:[Title]){
        self.titles = titles
//        print(titles)
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    //download movie title
    private func downloadTitleAt(indexPaths :[IndexPath]){
        
        for indexPath in indexPaths{
            guard let titlesItem = titles[indexPath.item].original_title else{return}
            
            DataPersistenceManager.shared.downloadTitleWith(model: titles[indexPath.item]) { result in
                switch result{
                case .success():
                    //update new download notification to DownloadViewController.
                    NotificationCenter.default.post(name: Notification.Name("downloaded"), object: nil)
                    print("downloaded \(titlesItem) to database.")
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            
        }
    }
    
    
}


//MARK: collectionview
extension CollectionViewTableViewCell:UICollectionViewDataSource, UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCollectionViewCell.identifier, for: indexPath) as? TitleCollectionViewCell else{
            return UICollectionViewCell()
        }
        
        
        
        guard let model = titles[indexPath.row].poster_path else {
            return UICollectionViewCell()
        }
//        print(model)
        cell.configure(with: model)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let title = titles[indexPath.row]
        guard let titleName = title.original_title ?? title.original_name else{return}
        
        APICaller.shared.getYoutubeMovie(query:titleName + " trailer ") { [weak self] result in
            switch result{
            case .success(let videoElement):
                guard let self = self else{return}
//                print(titles)
                let title = self.titles[indexPath.row]
                guard let overView = title.overview else{return}
                
                let viewModel = TitlePreviewViewModel(title: titleName, youtubeView: videoElement , titleOverview: overView)
                self.delegate?.colectionviewCellDidTapCell(viewModel: viewModel)
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    
    //long press to pop UIMenu and download movie
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemsAt indexPaths: [IndexPath], point: CGPoint) -> UIContextMenuConfiguration? {
        
        let config = UIContextMenuConfiguration(
            identifier: nil,
            previewProvider: nil) { [weak self] _ in
                
                let downloadAction = UIAction(
                    title: "Download",subtitle: nil,
                    image: nil,identifier: nil,
                    discoverabilityTitle: nil,state: .off) { _ in
                        self?.downloadTitleAt(indexPaths: indexPaths)
                    }
                                
                return UIMenu(title: "",image: nil, identifier: nil, options: .displayInline, children: [downloadAction])
        }
        return config
    }
    
}
