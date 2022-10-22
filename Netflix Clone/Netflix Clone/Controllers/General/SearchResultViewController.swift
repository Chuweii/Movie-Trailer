//
//  SearchResultViewController.swift
//  Netflix Clone
//
//  Created by Wei Chu on 2022/9/29.
//

import UIKit

protocol SearchResulCollectionViewDelegate:AnyObject{
    func SearchResulCollectionViewCellDidTapItem( viewModel:TitlePreviewViewModel )
}


class SearchResultViewController: UIViewController {
    
    public var titles = [Title]()
    
    weak var delegate:SearchResulCollectionViewDelegate?
    
    public let searchCollectionView:UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        //調整cell的大小
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width / 3 - 10, height: 200)
        
        //collectionview 中 cell 的水平方向間距
        layout.minimumInteritemSpacing = 0
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: TitleCollectionViewCell.identifier)
        
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        view.addSubview(searchCollectionView)
        searchCollectionView.delegate = self
        searchCollectionView.dataSource = self
        
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        searchCollectionView.frame = view.bounds
    }
    
}


extension SearchResultViewController:UICollectionViewDataSource, UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = searchCollectionView.dequeueReusableCell(withReuseIdentifier: TitleCollectionViewCell.identifier, for: indexPath) as? TitleCollectionViewCell else{
            return UICollectionViewCell() 
        }
        let title = titles[indexPath.row]
        cell.configure(with: title.poster_path ?? "")
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        searchCollectionView.deselectItem(at: indexPath, animated: true)
        
        let title = titles[indexPath.row]
        guard let titleName = title.original_title ?? title.original_name else{return}
        
        APICaller.shared.getYoutubeMovie(query: titleName + " trailer ") { [weak self] result  in
            guard let self = self else{return}
            switch result {
            case .success(let videoElement):
                self.delegate?.SearchResulCollectionViewCellDidTapItem(viewModel: TitlePreviewViewModel(title: titleName, youtubeView: videoElement, titleOverview: title.overview ?? ""))
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
    }
    
}
