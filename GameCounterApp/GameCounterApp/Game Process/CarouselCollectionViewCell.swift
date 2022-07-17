//
//  CarouselCollectionViewCell.swift
//  GameCounterApp
//
//  Created by Nadezhda Zenkova on 30.08.2021.
//

import UIKit

final class CarouselCollectionViewCell: UICollectionViewCell {

    // MARK: - SubViews
    
    private var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Nunito-ExtraBold", size: 28)
        label.textColor = .customOrange
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private lazy var scoreLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Nunito-ExtraBold", size: 100)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    
    // MARK: - Properties
    
    static let cellId = "CarouselCollectionViewCell"
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    // MARK: - Setups
    
    func setupUI() {
        backgroundColor = .lightDark
        layer.cornerRadius = 15
        
        addSubview(nameLabel)
        addSubview(scoreLabel)
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 20.0),
            nameLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            scoreLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            scoreLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    // MARK: - Public
    
    public func configure(name: String, score: Int) {
            nameLabel.text = name
            scoreLabel.text = "\(score)"
        }
    
}
