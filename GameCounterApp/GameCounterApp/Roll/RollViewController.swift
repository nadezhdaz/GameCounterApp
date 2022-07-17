//
//  RollViewController.swift
//  GameCounterApp
//
//  Created by Nadezhda Zenkova on 29.08.2021.
//

import UIKit
import AudioToolbox

class RollViewController: UIViewController {
    
    var diceNumber: Int?
    
    private let imageView: UIImageView = {
        let view = UIImageView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.layer.cornerRadius = 10.0
        
        view.sizeToFit()
        
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.clear
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        setupDiceRoll()
        
    }
    
    private func setupUI() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissViewController))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        setupBlurView()
    }
    
    private func setupBlurView() {
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.frame
        
        view.addSubview(blurEffectView)
        view.addSubview(imageView)
        blurEffectView.alpha = 0.9
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            blurEffectView.widthAnchor.constraint(equalTo: view.widthAnchor),
            blurEffectView.heightAnchor.constraint(equalTo: view.heightAnchor),
            blurEffectView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            blurEffectView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
                    ])
    }
    
    private func setupDiceRoll() {
        let diceRoll = Int.random(in: 1..<7)
        diceNumber = diceRoll
        let imageName = "dice_\(diceRoll)"
        imageView.image = UIImage(named: imageName)
        animateDiceRolling()
    }
    
    func animateDiceRolling() {
        let rotation : CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.toValue = NSNumber(value: Double.pi * 2)
        rotation.duration = 1.0
        rotation.isCumulative = true
        rotation.repeatCount = 1
        imageView.layer.add(rotation, forKey: "rotationAnimation")
    }
    

    @objc private func dismissViewController() {
        dismiss(animated: false, completion: nil)
    }

}


