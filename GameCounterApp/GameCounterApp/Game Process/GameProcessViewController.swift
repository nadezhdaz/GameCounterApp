//
//  GameProcessViewController.swift
//  GameCounterApp
//
//  Created by Nadezhda Zenkova on 29.08.2021.
//

import UIKit

final class GameProcessViewController: UIViewController, CarouselViewDelegate {
    var isTimerOn = false
    private var playerData = [Player]()
    private var turnsData = [Turn]()
    private var timer = Timer()
    private var startTime: TimeInterval?
    private var currentTime: TimeInterval?
    var currentPlayer = 0
    
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Nunito-ExtraBold", size: 36.0) ?? .systemFont(ofSize: 17.0)
        label.text = "Game"
        label.textColor = .white
        return label
    }()
    
    private lazy var rollButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "icon_Dice"), for: .normal)
        button.addTarget(self, action: #selector(rollImagePressed), for: .touchUpInside)
        return button
    }()
    
    private lazy var rightButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "Results", style: .plain, target: self, action: #selector(resultsButtonPressed))
        return button
    }()
    
    private lazy var leftButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "New Game", style: .plain, target: self, action: #selector(newGameButtonPressed))
        return button
    }()
    
    private let timerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = true
        view.heightAnchor.constraint(equalToConstant: 30.0).isActive = true
        return view
    }()
    
    private let timerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Nunito-ExtraBold", size: 28.0) ?? .systemFont(ofSize: 17.0)
        label.text = "00:00"
        label.textColor = .white
        return label
    }()
    
    private var timerButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont(name: "Nunito-ExtraBold", size: 17)
        button.setImage(UIImage(named: "play"), for: .normal)
        button.clipsToBounds = true
        //button.isHidden = true
        button.addTarget(self, action: #selector(timerButtonPressed), for: .touchUpInside)
        return button
    }()
    
    init(game: Game) {
        super.init(nibName: nil, bundle: nil)
        playerData = game.players
        turnsData = game.turns
        currentTime = game.timing?.currentTime
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .dark
        setupUI()
        
        NotificationCenter.default.addObserver(self, selector: #selector(saveGame), name: UIApplication.willResignActiveNotification, object: nil)
    }
    
    private func setupUI() {
        setupNavigationBar()
        view.addSubview(titleLabel)
        view.addSubview(rollButton)
        view.addSubview(timerView)
        timerView.addSubview(timerLabel)
        timerView.addSubview(timerButton)
        
        let carousel = CarouselView(players: playerData, currentPage: currentPlayer)
        carousel.translatesAutoresizingMaskIntoConstraints = false
        carousel.configure(with: playerData)
        carousel.delegate = self
        view.addSubview(carousel)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20.0),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12.0),
            
            rollButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 14.0),
            rollButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20.0),
            
            //timerLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            //timerLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 29.0),
            
            //timerButton.leadingAnchor.constraint(equalTo: timerLabel.trailingAnchor, constant: 20.0),
            timerButton.centerYAnchor.constraint(equalTo: timerLabel.centerYAnchor),
            timerLabel.centerYAnchor.constraint(equalTo: timerView.centerYAnchor),//
            
            timerView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            timerView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 29.0),
            timerView.bottomAnchor.constraint(equalTo: carousel.topAnchor),
            
            timerLabel.leadingAnchor.constraint(equalTo: timerView.leadingAnchor),
            timerLabel.trailingAnchor.constraint(equalTo: timerButton.leadingAnchor, constant: -20.0),
            timerButton.trailingAnchor.constraint(equalTo: timerView.trailingAnchor),
            
            //carousel.topAnchor.constraint(equalTo: timerView.bottomAnchor, constant: -32.0),//timerLabel.bounds.size.height),
            carousel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            carousel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            carousel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
        
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.isHidden = false
        navigationItem.leftBarButtonItem = leftButton
        navigationItem.rightBarButtonItem = rightButton
    }
    
    @objc private func resultsButtonPressed() {
        pauseTimer()
        let resultsViewController = ResultsViewController(players: playerData, turns: turnsData)
        navigationController?.pushViewController(resultsViewController, animated: true)
    }
    
    @objc private func newGameButtonPressed() {
        pauseTimer()
        let newGameViewController = NewGameViewController()
        newGameViewController.modalPresentationStyle = .fullScreen
        present(NavigationController(rootViewController: newGameViewController), animated: true, completion: nil)
    }
    
    @objc private func rollImagePressed() {
        let rollViewController = RollViewController()
        rollViewController.modalPresentationStyle = .overCurrentContext
        present(rollViewController, animated: false, completion: nil)
    }
    
    @objc private func timerButtonPressed() {
        if timer.isValid {
            timer.invalidate()
            timerButton.setImage(UIImage(named: "play"), for: .normal)
            timerLabel.alpha = 0.5
            currentTime = Date.timeIntervalSinceReferenceDate
        } else {
            startTimer()
        }
    }
    
    @objc private func updateTime() {
        guard let start = startTime else { return }
        let duration = Date.timeIntervalSinceReferenceDate - start
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [ .minute, .second ]
        formatter.zeroFormattingBehavior = [ .pad ]
        let formattedDuration = formatter.string(from: duration)
        timerLabel.text = formattedDuration
    }
    
    @objc private func saveGame() {
        GameSaver().updateGame(to: Game(firstStart: false, players: playerData, turns: turnsData, timing: Timing(currentTime: currentTime)))
    }
    
    func stopTimer() {
        timer.invalidate()
        timerButton.setImage(UIImage(named: "play"), for: .normal)
        timerLabel.alpha = 0.5
        
        startTime = nil
        currentTime = nil
    }
    
    func startTimer() {
        timerButton.setImage(UIImage(named: "pause"), for: .normal)
        timerLabel.alpha = 1.0
        
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
        RunLoop.main.add(timer, forMode: .common)
        
        if startTime != nil {
            if let currentTime = currentTime {
                self.startTime! += (Date.timeIntervalSinceReferenceDate - currentTime)
            }
            else {
                return
            }
        }
        else {
            self.startTime = Date.timeIntervalSinceReferenceDate
            
        }
    }
    
    func pauseTimer() {
        timer.invalidate()
        timerButton.setImage(UIImage(named: "play"), for: .normal)
        timerLabel.alpha = 0.5
        currentTime = Date.timeIntervalSinceReferenceDate
    }
    
    func changeTurn(_ turn: Turn) {
        stopTimer()
        currentPlayer = turn.currentPlayer
        turnsData.append(turn)
        playerData[currentPlayer].score = turn.lastScore
        startTimer()
    }
    
    func undoLastTurn() -> Turn? {
        guard let turn = turnsData.popLast() else { return nil }
        playerData[turn.currentPlayer].score = turn.lastScore
        return turn
    }

}
