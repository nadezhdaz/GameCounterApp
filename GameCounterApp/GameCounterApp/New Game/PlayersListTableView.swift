//
//  PlayersListTableView.swift
//  GameCounterApp
//
//  Created by Nadezhda Zenkova on 27.08.2021.
//

import UIKit

final class PlayersListTableView: UITableView {    
    var maxHeight: CGFloat = UIScreen.main.bounds.size.height - 220.0 //startGameButton.heightAnchor + bottomAnchor + spacing

      override func reloadData() {
        super.reloadData()
        self.invalidateIntrinsicContentSize()
        self.layoutIfNeeded()
      }
    
    override var contentSize: CGSize {
            didSet {
                invalidateIntrinsicContentSize()
                setNeedsLayout()
            }
        }
      
      override var intrinsicContentSize: CGSize {
        //let height = min(bounds.size.height, maxHeight)// + (tableFooterView?.frame.height ?? CGFloat(59))
        let height = min(contentSize.height, maxHeight)// + (tableFooterView?.frame.height ?? CGFloat(59))
        return CGSize(width: contentSize.width, height: height)
      }

}
