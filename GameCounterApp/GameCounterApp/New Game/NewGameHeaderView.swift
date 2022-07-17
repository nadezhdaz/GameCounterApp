//
//  NewGameHeaderView.swift
//  GameCounterApp
//
//  Created by Nadezhda Zenkova on 27.08.2021.
//

import UIKit

final class NewGameHeaderView: UITableViewHeaderFooterView {
    static let reuseIdentifier: String = String(describing: self)
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        backgroundView?.backgroundColor = .dark
        
        contentView.backgroundColor = .lightDark
        textLabel?.textColor = .customGray
        textLabel?.font = UIFont(name: "Nunito-SemiBold", size: 16)
    }
    required init?(coder aDecoder: NSCoder) {
           super.init(coder: aDecoder)
       }
}
