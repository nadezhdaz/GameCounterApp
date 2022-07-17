//
//  RoundButton.swift
//  GameCounterApp
//
//  Created by Nadezhda Zenkova on 27.08.2021.
//

import UIKit

class RoundButton: UIButton {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.width / 2
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init(number: Int?, toPlus plusOrMinus: Bool, size: CGFloat = 55.0) {
        self.number = number
        self.operation = plusOrMinus
        self.isFooterButton = size == 25.0
        super.init(frame: .zero)
        setupButton(with: size)
        let title = number != nil ? "\(plusOrMinus ? "+" : "-")\(number!)" : "\(plusOrMinus ? "+" : "-")"
        setTitle(title, for: .normal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open var operation: Bool?
    open var number: Int?
    private var isFooterButton: Bool?
    
    override open var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? UIColor.lightGreen.withAlphaComponent(0.5) : UIColor.lightGreen
        }
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if self.point(inside: point, with: event) {
            self.isHighlighted = true
            return self
        }
        return super.hitTest(point, with: event)
    }
    
    func setupButton(with diameter: CGFloat) {
        backgroundColor = UIColor.lightGreen
        titleLabel?.font = UIFont(name: "Nunito-ExtraBold", size: 25)
        if !(isFooterButton ?? true) {
            titleLabel?.layer.shadowColor = UIColor.darkGreen.cgColor
            titleLabel?.layer.shadowOffset = CGSize(width: 0, height: 2.0)
            titleLabel?.layer.shadowRadius = 0
            titleLabel?.layer.shadowOpacity = 1.0
        }
        clipsToBounds = true
        layer.masksToBounds = false
        layer.cornerRadius = bounds.width / 2
        layer.cornerRadius = 20
        clipsToBounds = true
        translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: diameter),
            widthAnchor.constraint(equalToConstant: diameter)
        ])
    }

}
