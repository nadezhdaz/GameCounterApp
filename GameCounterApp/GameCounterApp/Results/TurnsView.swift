//
//  TurnsTableView.swift
//  GameCounterApp
//
//  Created by Nadezhda Zenkova on 31.08.2021.
//

import UIKit

final class TurnsView: UIView, UITableViewDelegate, UITableViewDataSource {
    
    private var turns = [Turn]()
    
    
    private lazy var turnsTableView: PlayersListTableView = {
        let tableView = PlayersListTableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .lightDark
        tableView.separatorColor = .customGray
        tableView.delegate = self
        tableView.dataSource = self
        tableView.layer.cornerRadius = 15
        tableView.showsVerticalScrollIndicator = false
        tableView.contentInsetAdjustmentBehavior = .always
        tableView.allowsSelection = true
        tableView.register(NewGameHeaderView.self, forHeaderFooterViewReuseIdentifier: "NewGameHeaderId")
        return tableView
    }()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return turns.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "TurnsCell")
        cell.textLabel?.text = turns[indexPath.row].playerName
        cell.textLabel?.textColor = .white
        cell.textLabel?.font = UIFont(name: "Nunito-ExtraBold", size: 20)
        cell.backgroundColor = .lightDark
        cell.detailTextLabel?.text = "\(turns[indexPath.row].scoreChanged)"
        cell.detailTextLabel?.textColor = .white
        cell.detailTextLabel?.font = UIFont(name: "Nunito-ExtraBold", size: 20)
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Turns"
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "NewGameHeaderId") as? NewGameHeaderView else { return UITableViewHeaderFooterView() }
        return header
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        57
    }
    
    public func configure(with data: [Turn]) {
        turns = data.reversed()
        turnsTableView.reloadData()
    }
    
    init() {
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(turnsTableView)
        
        
        NSLayoutConstraint.activate([
            turnsTableView.topAnchor.constraint(equalTo: topAnchor),
            turnsTableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            turnsTableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            turnsTableView.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor)
        ])
    }

}
