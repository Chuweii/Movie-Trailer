//
//  HeroHeaderUIView.swift
//  Netflix Clone
//
//  Created by Wei Chu on 2022/9/24.
//

import UIKit

class HeroHeaderUIView: UIView {
    
    //set background image
    private let heroImageView:UIImageView = {
       
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "heroImage")
        imageView.isUserInteractionEnabled = true
        
        
        return imageView
    }()
    
    //set button (play & download)
    private let playButton:UIButton = {
       
        let button = UIButton()
        button.setTitle("Play", for: .normal)
        button.layer.borderColor = UIColor.white.cgColor
        button.setTitle("Plays", for: .selected)
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.addTarget(self, action: #selector(tapToPlayVideo), for: .touchUpInside)
        
        if button.isSelected == true{
            button.backgroundColor = .lightGray
            
        }
        
        return button
    }()
    
    private let downloadButton:UIButton = {
       
        let button = UIButton()
        button.setTitle("Download", for: .normal)
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.addTarget(self, action: #selector(tapToDownloadVideo), for: .touchUpInside)

        
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(heroImageView)
        addGradient()
        addSubview(playButton)
        addSubview(downloadButton)
        
    }
        
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        heroImageView.frame = bounds
        applyConstraints()

    }
    
    public func configure(with model:UpcomingTableViewCellViewModel){
        
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500\(model.titleImage)") else {
            return
        }
        
        heroImageView.downloaded(from: url)
    }
    
}

//set constraints and button action
extension HeroHeaderUIView{
    
    func applyConstraints(){
        
        let imageViewConsraints = [

            heroImageView.widthAnchor.constraint(equalToConstant: self.frame.width)

        ]
        
        let playButtonConstraints = [
            playButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 90),
            playButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -50),
            playButton.widthAnchor.constraint(equalToConstant: 100)
        ]
        
        let downloadButtonConstraints = [
            downloadButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -90),
            downloadButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -50),
            downloadButton.widthAnchor.constraint(equalToConstant: 100)
        ]
        
        
        NSLayoutConstraint.activate(playButtonConstraints)
        NSLayoutConstraint.activate(downloadButtonConstraints)
        NSLayoutConstraint.activate(imageViewConsraints)
    }
    
    //button action
    @objc func tapToPlayVideo(){
        print("play video...")
        playButton.backgroundColor = .lightGray
    }

    @objc func tapToDownloadVideo(){
        print("download video...")
        downloadButton.backgroundColor = .lightGray
    }
    
    
}

//background gradient
extension HeroHeaderUIView{
    
    private func addGradient(){
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor.clear.cgColor,
            UIColor.systemBackground.cgColor
        ]
        gradientLayer.frame = bounds
        layer.addSublayer(gradientLayer)
    }
}

