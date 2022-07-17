//
//  AddPlayerViewController.swift
//  GameCounterApp
//
//  Created by Nadezhda Zenkova on 29.08.2021.
//

import UIKit

final class AddPlayerViewController: UIViewController, UITextFieldDelegate {
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Nunito-ExtraBold", size: 36.0) ?? .systemFont(ofSize: 17.0)
        label.text = "Add Player"
        label.textColor = .white
        return label
    }()
    
    private lazy var playerNameTextField: UITextField = {
        let textField = UITextField()
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.keyboardType = .alphabet
        textField.tintColor = .customDarkGray
        textField.textColor = .customDarkGray
        textField.backgroundColor = .lightDark
        let font = UIFont(name: "Nunito-ExtraBold", size: 20.0) ?? .systemFont(ofSize: 17.0)
        textField.font = font
        
        let customPlaceholderText = NSAttributedString(string: "Player Name", attributes: [ .foregroundColor: UIColor.customDarkGray, .font: font])
        textField.attributedPlaceholder = customPlaceholderText
        textField.delegate = self
        
        let leftView = UIView(frame: CGRect(x:0, y:0, width:24, height:textField.frame.size.height))
        leftView.backgroundColor = textField.backgroundColor
        textField.leftView = leftView
        textField.leftViewMode = .always
        textField.becomeFirstResponder()
        textField.addTarget(self, action: #selector(textFieldWasChanged(_:)), for: .editingChanged)
                
        return textField
    }()
    
    private lazy var rightButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addButtonPressed))
        button.isEnabled = false
        return button
    }()
    
    private lazy var leftButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(backButtonPressed))
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .dark
        setupUI()
    }
    
    private func setupUI() {
        setupNavigationBar()
        view.addSubview(titleLabel)
        view.addSubview(playerNameTextField)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20.0),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12.0),
            
            playerNameTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 25.0),
            playerNameTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            playerNameTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            playerNameTextField.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    

    private func setupNavigationBar() {
        navigationController?.navigationBar.isHidden = false
        navigationItem.leftBarButtonItem = leftButton
        navigationItem.rightBarButtonItem = rightButton
    }
    
    func addNewPlayer() {        
        navigationController?.viewControllers.forEach {
            viewController in (viewController as? NewGameViewController)?.addPlayer(name: playerNameTextField.text ?? "")
        }
        playerNameTextField.text = nil
    }
    
    @objc func textFieldWasChanged(_ textField: UITextField){
        rightButton.isEnabled = textField.hasText
    }
    
    @objc private func backButtonPressed() {
        playerNameTextField.text = nil
        navigationController?.popToViewController(ofClass: NewGameViewController.self)
    }
    
    @objc private func addButtonPressed() {
        addNewPlayer()
        navigationController?.popToViewController(ofClass: NewGameViewController.self)
    }

}
