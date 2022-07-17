//
//  ResultsViewController.swift
//  GameCounterApp
//
//  Created by Nadezhda Zenkova on 29.08.2021.
//

import UIKit

final class ResultsViewController: UIViewController {
    
    var playersData = [Player]()
    var turnsData = [Turn]()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Nunito-ExtraBold", size: 36.0) ?? .systemFont(ofSize: 17.0)
        label.text = "Results"
        label.textColor = .white
        return label
    }()
    
    private lazy var rightButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "Resume", style: .plain, target: self, action: #selector(resumeButtonPressed))
        return button
    }()
    
    private lazy var leftButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "New Game", style: .plain, target: self, action: #selector(newGameButtonPressed))
        return button
    }()
    
    private lazy var topPlayersView: TopPlayersView = {
        let tableview = TopPlayersView()
        tableview.translatesAutoresizingMaskIntoConstraints = false
        return tableview
    }()
    
    private lazy var turnsView: TurnsView = {
        let tableview = TurnsView()
        tableview.translatesAutoresizingMaskIntoConstraints = false
        return tableview
    }()
    
    init(players: [Player], turns: [Turn]) {
        super.init(nibName: nil, bundle: nil)
        playersData = players
        turnsData = turns
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .dark
        setupUI()
    }
    
    private func setupUI() {
        setupNavigationBar()
        turnsView.configure(with: turnsData)
        topPlayersView.configure(with: playersData)
        view.addSubview(titleLabel)
        view.addSubview(topPlayersView)
        view.addSubview(turnsView)
        
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20.0),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12.0),
            
            topPlayersView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            topPlayersView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            topPlayersView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            topPlayersView.heightAnchor.constraint(equalToConstant: 160.0),
            
            turnsView.topAnchor.constraint(equalTo: topPlayersView.bottomAnchor, constant: 20.0),
            turnsView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            turnsView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            turnsView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.isHidden = false
        navigationItem.leftBarButtonItem = leftButton
        navigationItem.rightBarButtonItem = rightButton
    }
    
    @objc private func resumeButtonPressed() {
        navigationController?.popToViewController(ofClass: GameProcessViewController.self)
    }
    
    @objc private func newGameButtonPressed() {
        let newGameViewController = NewGameViewController()
        newGameViewController.modalPresentationStyle = .fullScreen
        present(NavigationController(rootViewController: newGameViewController), animated: true, completion: nil)
    }

}
