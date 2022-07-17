//
//  EditButton.swift
//  GameCounterApp
//
//  Created by Nadezhda Zenkova on 31.08.2021.
//

import UIKit

class EditButton: UIButton {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.width / 2
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override open var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? UIColor.customRed.withAlphaComponent(0.5) : UIColor.customRed
        }
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if self.point(inside: point, with: event) {
            self.isHighlighted = true
            return self
        }
        return super.hitTest(point, with: event)
    }
    
    func setupButton() {
        setTitle("-", for: .normal)
        backgroundColor = UIColor.customRed
        titleLabel?.font = UIFont(name: "Nunito-ExtraBold", size: 17)
        clipsToBounds = true
        layer.masksToBounds = false
        layer.cornerRadius = bounds.width / 2
        layer.cornerRadius = 20
        clipsToBounds = true
        translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 25.0),
            widthAnchor.constraint(equalToConstant: 25.0)
        ])
    }

}

