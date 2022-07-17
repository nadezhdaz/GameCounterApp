//
//  NewGameFooterView.swift
//  GameCounterApp
//
//  Created by Nadezhda Zenkova on 27.08.2021.
//

import UIKit

final class NewGameFooterView: UITableViewHeaderFooterView {
    
    var footerTappedBlock: (() -> Void)?
    
    private lazy var plusVariantButton: UIButton = {
        let button = UIButton()
        let diameter: CGFloat = 25
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .lightGreen
        button.setTitle("+", for: .normal)
        button.clipsToBounds = true
        //button.layer.masksToBounds = true
        button.heightAnchor.constraint(equalToConstant: diameter).isActive = true
        button.widthAnchor.constraint(equalToConstant: diameter).isActive = true
        button.layer.cornerRadius = diameter / 2.0
        button.addTarget(self, action: #selector(viewTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var plusButton: RoundButton = {
        let button = RoundButton(number: nil, toPlus: true, size: 25.0)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(viewTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var plusView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.lightGreen
        view.layer.cornerRadius = 0.5 * bounds.size.width
        view.clipsToBounds = true
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .lightGreen
        label.font = UIFont(name: "Nunito-SemiBold", size: 16)
        label.text = "Add player"
        
        return label
    }()

        override init(reuseIdentifier: String?) {
            super.init(reuseIdentifier: reuseIdentifier)
            //backgroundView?.backgroundColor = .lightDark
            configureContents()
        }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
        func configureContents() {
            contentView.backgroundColor = .lightDark
            
            contentView.addSubview(plusButton)
            contentView.addSubview(titleLabel)
            //contentView.addSubview(plusView)
            
            let gesture:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
            gesture.numberOfTapsRequired = 1
            contentView.isUserInteractionEnabled = true
            contentView.addGestureRecognizer(gesture)

            // Center the image vertically and place it near the leading
            // edge of the view. Constrain its width and height to 50 points.
            NSLayoutConstraint.activate([
                plusButton.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),//constant: 15.0),
                //plusButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
                plusButton.topAnchor.constraint(equalTo: contentView.topAnchor),
                //plusButton.heightAnchor.constraint(equalToConstant: 25.0),
                //plusButton.widthAnchor.constraint(equalToConstant: 25.0),
                //plusView.widthAnchor.constraint(equalToConstant: 25.0),
                //plusView.heightAnchor.constraint(equalToConstant: 25.0),
                //plusView.widthAnchor.constraint(equalToConstant: 25.0),
                //plusView.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),//constant: 15.0),
                //plusView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
                titleLabel.leadingAnchor.constraint(equalTo:plusButton.trailingAnchor, constant: 16.0),
                //titleLabel.leadingAnchor.constraint(equalTo:plusView.trailingAnchor, constant: 16.0),
                titleLabel.centerYAnchor.constraint(equalTo: plusButton.centerYAnchor)
            ])
        }
    
    @objc func viewTapped() {
            footerTappedBlock?()
        }
}
