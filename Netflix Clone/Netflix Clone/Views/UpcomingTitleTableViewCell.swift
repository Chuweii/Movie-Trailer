//
//  UpcomingTitleTableViewCell.swift
//  Netflix Clone
//
//  Created by Wei Chu on 2022/9/29.
//

import UIKit

class UpcomingTitleTableViewCell: UITableViewCell {

    static let identifier = "UpcomingTitleTableViewCell"
    
    private let titleImage:UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.translatesAutoresizingMaskIntoConstraints = false
        image.clipsToBounds = true
        return image
    }()
    
    private let titleLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17)
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let playButton:UIButton = {
        let button = UIButton()
        //設定btn圖片樣式以及大小
        let btnImage = UIImage(systemName: "play.circle",withConfiguration: UIImage.SymbolConfiguration(pointSize: 30))
        button.setImage(btnImage, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .white

        
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(titleImage)
        contentView.addSubview(titleLabel)
        contentView.addSubview(playButton)
        
        applyConstraints()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }

    public func configure(with viewmodel:UpcomingTableViewCellViewModel){
        
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500\(viewmodel.titleImage)") else {
            return
        }
//        print(url)
        titleImage.downloaded(from: url)
        titleLabel.text = viewmodel.titleLabel
    }
    
}

//set constraints
extension UpcomingTitleTableViewCell{
    private func applyConstraints(){
        
        let titleImageConstraints = [
            titleImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titleImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            titleImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            titleImage.widthAnchor.constraint(equalToConstant: 100)
        ]
        
        let titleLabelConstraints = [
            titleLabel.leadingAnchor.constraint(equalTo: titleImage.trailingAnchor, constant: 20),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleLabel.widthAnchor.constraint(equalToConstant: 150)
        ]
        
        let playButtonConstraints = [
            playButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -20),
            playButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
            
        ]
        
        NSLayoutConstraint.activate(titleImageConstraints)
        NSLayoutConstraint.activate(titleLabelConstraints)
        NSLayoutConstraint.activate(playButtonConstraints)
    }
}
