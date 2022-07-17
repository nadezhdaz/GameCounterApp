//
//  PlayerTableViewCell.swift
//  GameCounterApp
//
//  Created by Nadezhda Zenkova on 29.08.2021.
//

import UIKit

final class PlayerTableViewCell: UITableViewCell {
    
    static let cellId = "PlayerTableViewCell"
    
    private var selectImageView: UIImageView?
    let editButton = EditButton()

    override func awakeFromNib() {
        super.awakeFromNib()
        setupEditControl()
        //setupReorderControl()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        //setupUI()
        setupEditControl()
        //setupReorderControl()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupEditControl()
        //setupReorderControl()
        
        textLabel?.textColor = .white
        textLabel?.font = UIFont(name: "Nunito-ExtraBold", size: 20)
        backgroundColor = .lightDark
        isEditing = true
            
            
        }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        customMultipleChioce()
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        setupEditControl()

        if editing {
            for view in subviews where view.description.contains("Edit") {
                view.tintColor = .lightGreen//where view.description.contains("Reorder") {
                selectedBackgroundView?.backgroundColor = UIColor.clear
                for case let subview as UIImageView in view.subviews {
                    subview.tintColor = .lightGreen
                }
            }
        }
    }
    
    //override func layoutSubviews() {
    //    customMultipleChioce()
    //    super.layoutSubviews()
    //}
    
    override func layoutSubviews() {
        super.layoutSubviews()
           
        setupEditControl()
        //setupReorderControl()
    }
    
    private func customMultipleChioce() {
        for control in subviews {
            control.tintColor = .lightGreen
            selectedBackgroundView?.backgroundColor = UIColor.clear
            //Subview of circular cell
            if control.isMember(of: NSClassFromString("UITableViewCellEditControl")!.self) {
                
                control.tintColor = .lightGreen
                selectedBackgroundView?.backgroundColor = UIColor.clear
                
                }
            }
    }
}

