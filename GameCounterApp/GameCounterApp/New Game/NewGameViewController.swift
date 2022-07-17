//
//  NewGameViewController.swift
//  GameCounterApp
//
//  Created by Nadezhda Zenkova on 25.08.2021.
//

import UIKit

final class NewGameViewController: UIViewController , UITableViewDelegate, UITableViewDataSource {
    
    var userDefaults = UserDefaults.standard
    
    private var playersList: [Player] = [Player(name: "Me", score: 0), Player(name: "You", score: 0)]
    private let firstStart = UserDefaults.standard.bool(forKey: "FirstStart")
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Nunito-ExtraBold", size: 36.0) ?? .systemFont(ofSize: 17.0)
        label.text = "Game Counter"
        label.textColor = .white        
        return label
    }()
    
    private lazy var playersTableView: PlayersListTableView = {
        let tableView = PlayersListTableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .lightDark
        tableView.separatorColor = .customGray
        tableView.delegate = self
        tableView.dataSource = self
        //tableView.isUserInteractionEnabled = true
        tableView.register(NewGameHeaderView.self, forHeaderFooterViewReuseIdentifier: "NewGameHeaderId")
        tableView.register(NewGameFooterView.self, forHeaderFooterViewReuseIdentifier: "NewGameFooterId")
        //tableView.register(PlayerTableViewCell.self, forCellReuseIdentifier: PlayerTableViewCell.cellId)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "NewGameCellId")
        //tableView.register(PlayersListFooterTableViewCell.self, forCellReuseIdentifier: "NewGameFooterCellId")
        tableView.layer.cornerRadius = 15
        tableView.isEditing = true
        tableView.allowsMultipleSelectionDuringEditing = false
        tableView.showsVerticalScrollIndicator = false
        tableView.contentInsetAdjustmentBehavior = .always
        tableView.allowsSelection = true
        //tableView.tableHeaderView?.backgroundColor = .lightDark
        //tableView.tableFooterView = UIView()
        //tableView.maxHeight = 372
        //tableView.tableFooterView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 0, height: 1)))
        return tableView
        }()
    
    private lazy var startGameButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.backgroundColor = .lightGreen
        
        button.titleLabel?.font = UIFont(name: "Nunito-ExtraBold", size: 24)
        button.titleLabel?.layer.shadowColor = UIColor.darkGreen.cgColor
        button.titleLabel?.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        button.titleLabel?.layer.shadowRadius = 0
        button.titleLabel?.layer.shadowOpacity = 1.0
        button.setTitle("Start game", for: .normal)
        button.clipsToBounds = true
        button.layer.shadowColor = UIColor.darkGreen.cgColor
        button.layer.shadowRadius = 0
        button.layer.shadowOpacity = 1.0
        button.layer.shadowOffset = CGSize(width: 0, height: 6.0)
        button.layer.masksToBounds = false
        button.layer.cornerRadius = 25.0
        button.heightAnchor.constraint(equalToConstant: 65).isActive = true
        button.addTarget(self, action: #selector(startGame), for: .touchUpInside)
        return button
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont(name: "Nunito-ExtraBold", size: 17)
        button.setTitle("Cancel", for: .normal)
        button.setTitleColor(.lightGreen, for: .normal)
        button.clipsToBounds = true
        if isBeingPresented {
            button.isHidden = false
        }
        button.addTarget(self, action: #selector(cancelPlayersList), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if !(firstStart), let players = GameSaver().currentGame?.players {
            self.playersList = players
        }
        view.backgroundColor = .dark
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        playersTableView.reloadData()
        playersTableView.layoutIfNeeded()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playersList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewGameCellId", for: indexPath)
        cell.textLabel?.text = playersList[indexPath.row].name
        cell.textLabel?.textColor = .white
        cell.textLabel?.font = UIFont(name: "Nunito-ExtraBold", size: 20)
        cell.backgroundColor = .lightDark
        cell.isEditing = true
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Players"
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let footer = tableView.dequeueReusableHeaderFooterView(withIdentifier: "NewGameFooterId") as? NewGameFooterView else { return UITableViewCell() }
        footer.footerTappedBlock = { [weak self] in self?.addAction() }
        let gesture:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(addAction))
        gesture.numberOfTapsRequired = 1
        footer.isUserInteractionEnabled = true
        footer.addGestureRecognizer(gesture)
        return footer
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.setupEditControl()
        
            for view in cell.subviews {
                if view.self.description.contains("UITableViewCellReorderControl") {
                    for sort in view.subviews {
                        if (sort is UIImageView) {
                            (sort as? UIImageView)?.image = UIImage(named: "icon_sort")
                            (sort as? UIImageView)?.contentMode = .center
                        }
                    }
                }
            }
        }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "NewGameHeaderId") as? NewGameHeaderView else { return UITableViewHeaderFooterView() }        
        return header
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            //guard let players = playersList, !(players.isEmpty) else { return }
            playersList.remove(at: indexPath.row)
            playersTableView.deleteRows(at: [indexPath], with: .fade)

        }
    }
    
    /*func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        if indexPath.row == playersList.count {
            return .insert
        } else {
            return .delete
        }
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        if indexPath.row == playersList.count {
            return false
        } else {
            return true
        }
    }*/
    
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 54
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let row = sourceIndexPath.row
        let movedObject = playersList[row]
        playersList.remove(at: row)
        playersList.insert(movedObject, at: destinationIndexPath.row)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        addAction()
        if indexPath.row == playersList.count {
            addAction()
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    private func setupUI() {
        setupNavigationBar()
        view.addSubview(titleLabel)
        view.addSubview(cancelButton)
        view.addSubview(playersTableView)
        view.addSubview(startGameButton)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20.0),
            titleLabel.topAnchor.constraint(equalTo: cancelButton.bottomAnchor, constant: 12.0),
            
            cancelButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20.0),
            cancelButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            
            playersTableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 25.0),
            playersTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20.0),
            playersTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20.0),
            playersTableView.bottomAnchor.constraint(lessThanOrEqualTo: startGameButton.topAnchor, constant: -50.0),
            
            startGameButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -25.0),
            startGameButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20.0),
            startGameButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20.0),
        ])
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.isHidden = true
    }
    
    @objc func addAction() {
        let addPlayerViewController = AddPlayerViewController()
        navigationController?.pushViewController(addPlayerViewController, animated: true)
    }
    
    @objc private func cancelPlayersList() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func startGame() {
        guard !(playersList.isEmpty) else { return }
        let game = Game(firstStart: false, players: playersList, turns: [], timing: nil)
        GameSaver().updateGame(to: game)
        cancelButton.isHidden = false
        let gameProcessViewController = GameProcessViewController(game: game)
        
        navigationController?.viewControllers = [gameProcessViewController]
        dismiss(animated: true, completion: nil)
        navigationController?.pushViewController(gameProcessViewController, animated: true)
    }
    
    public func addPlayer(name: String) {
        playersList.append(Player(name: name, score: 0))
    }
    
    

}

extension UITableViewCell {
    func setupEditControl() {
        if let targetView = self.searchSubViewWithClassName("UITableViewCellEditControl") {
            for subview in targetView.subviews {
                if subview.isKind(of: UIImageView.classForCoder()) {
                    let imageView = subview as! UIImageView
                    imageView.contentMode = .scaleAspectFit
                    imageView.image = UIImage(named: "delete")
                }
            }
            
            
        }
    }

}

extension UIView {
    func searchSubViewWithClassName(_ className:String) -> UIView? {
        
        let subviewArray: [UIView] = subviews.reversed()
        var targetView: UIView?
        
        for view in subviewArray {
            
            if NSStringFromClass(view.classForCoder).elementsEqual(className) {
                targetView = view
                break
            }
            
        }
        return targetView
    }
}
