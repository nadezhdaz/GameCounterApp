//
//  PlayersListFooterTableViewCell.swift
//  GameCounterApp
//
//  Created by Nadezhda Zenkova on 27.08.2021.
//

import UIKit

final class PlayersListFooterTableViewCell: UITableViewCell {
    
    var footerTappedBlock: (() -> Void)?
    
    private lazy var plusButton: RoundButton = {
        let button = RoundButton(number: nil, toPlus: true)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "Add"), for: .normal)
        button.addTarget(self, action: #selector(viewTapped), for: .touchUpInside)
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Nunito-ExtraBold", size: 17.0) ?? .systemFont(ofSize: 17.0)
        label.text = "Add player"

        label.textColor = .lightGreen
        
        return label
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
        configureContents()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureContents() {
        contentView.backgroundColor = .systemBlue
        
        contentView.addSubview(plusButton)
        contentView.addSubview(titleLabel)
        
        let gesture:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        gesture.numberOfTapsRequired = 1
        gesture.cancelsTouchesInView = false
        contentView.isUserInteractionEnabled = true
        
        contentView.addGestureRecognizer(gesture)

        // Center the image vertically and place it near the leading
        // edge of the view. Constrain its width and height to 50 points.
        NSLayoutConstraint.activate([
            plusButton.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor, constant: 15.0),
            //titleLabel.widthAnchor.constraint(equalToConstant: 50),
            //titleLabel.heightAnchor.constraint(equalToConstant: 50),
            plusButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo:plusButton.trailingAnchor, constant: 16.0),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        
            // Center the label vertically, and use it to fill the remaining
            // space in the header view.
            //title.heightAnchor.constraint(equalToConstant: 30),
            //title.leadingAnchor.constraint(equalTo: image.trailingAnchor,                       constant: 8),
            //title.trailingAnchor.constraint(equalTo:                       contentView.layoutMarginsGuide.trailingAnchor),
            //title.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }

@objc func viewTapped() {
        footerTappedBlock?()
    }

}
