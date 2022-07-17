//
//  NavigationController.swift
//  GameCounterApp
//
//  Created by Nadezhda Zenkova on 26.08.2021.
//

import UIKit

final class NavigationController: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        //view.backgroundColor = .dark
        navigationBar.isTranslucent = false
        navigationBar.barTintColor = .dark
        navigationBar.tintColor = .lightGreen
        
        let barButtonItemFont = UIFont(name: "Nunito-ExtraBold", size: 17.0) ?? .systemFont(ofSize: 17.0)
        let titleFont = UIFont(name: "Nunito-ExtraBold", size: 17.0) ?? .systemFont(ofSize: 17.0)
        UIBarButtonItem.appearance().setTitleTextAttributes([ .foregroundColor: UIColor.lightGreen, .font: barButtonItemFont], for: .normal)
        UIBarButtonItem.appearance().setTitleTextAttributes([ .foregroundColor: UIColor.lightGreen.withAlphaComponent(0.4), .font: barButtonItemFont], for: .disabled)
        UINavigationBar.appearance().titleTextAttributes = [
            .foregroundColor: UIColor.lightGreen,
            .font: titleFont
                ]
    }
    
}

extension UINavigationController {
  func popToViewController(ofClass: AnyClass, animated: Bool = true) {
    if let vc = viewControllers.last(where: { $0.isKind(of: ofClass) }) {
      popToViewController(vc, animated: animated)
    }
  }
    
    func pushViewController(ofClass: AnyClass, animated: Bool = true) {
      if let vc = viewControllers.last(where: { $0.isKind(of: ofClass) }) {
        pushViewController(vc, animated: animated)
      }
    }
}


