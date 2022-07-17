//
//  TopPlayersView.swift
//  GameCounterApp
//
//  Created by Nadezhda Zenkova on 31.08.2021.
//

import UIKit

final class TopPlayersView: UIView, UITableViewDelegate, UITableViewDataSource {
    
    private var playersData = [Player]()
    
    private lazy var topPlayersTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.separatorColor = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "TopPlayerCell")
        tableView.contentInsetAdjustmentBehavior = .always
        tableView.allowsSelection = true
        return tableView
    }()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playersData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "TopPlayerCell")
        cell.backgroundColor = UIColor.clear

        let coloredString = NSMutableAttributedString(string: "#\(indexPath.row + 1) ", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        let coloredNameString = NSMutableAttributedString(string: playersData[indexPath.row].name, attributes: [NSAttributedString.Key.foregroundColor: UIColor.customOrange])

        coloredString.append(coloredNameString)
        
        cell.textLabel?.attributedText = coloredString
        cell.textLabel?.font = UIFont(name: "Nunito-ExtraBold", size: 28.0)

        cell.detailTextLabel?.text = "\(playersData[indexPath.row].score)"
        cell.detailTextLabel?.textColor = UIColor.white
        cell.detailTextLabel?.font = UIFont(name: "Nunito-ExtraBold", size: 28.0)
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        57
    }
    
    public func configure(with data: [Player]) {
        playersData = data.sorted(by: { if $0.score == $1.score {
                                        return $0.name < $1.name
                                    }
                                    return $0.score > $1.score })
        topPlayersTableView.reloadData()
    }
    
    init() {
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(topPlayersTableView)
        
        
        NSLayoutConstraint.activate([
            topPlayersTableView.topAnchor.constraint(equalTo: topAnchor),
            topPlayersTableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            topPlayersTableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            topPlayersTableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

}
