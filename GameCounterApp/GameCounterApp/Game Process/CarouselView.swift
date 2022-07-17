//
//  CarouselView.swift
//  GameCounterApp
//
//  Created by Nadezhda Zenkova on 30.08.2021.
//

import UIKit

protocol CarouselViewDelegate: class {
    //var currentPlayer: Int? { get set }
    func changeTurn(_ turn: Turn)
    func undoLastTurn() -> Turn?
}

final class CarouselView: UIView, UICollectionViewDataSource, UICollectionViewDelegate {
    
    enum Constants {
        static let screenWidth = UIScreen.main.bounds.width
        static let screenHeight = UIScreen.main.bounds.height
        static let calcButtonSize = UIScreen.main.bounds.width * 0.146
        static let mainCalcButtonSize = UIScreen.main.bounds.width * 0.24
        static let collectionHeight = UIScreen.main.bounds.height * 0.68
    }

       // MARK: - Subviews
    private lazy var carouselCollectionView: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collection.showsHorizontalScrollIndicator = false
        collection.isPagingEnabled = true
        collection.dataSource = self
        collection.delegate = self
        collection.register(CarouselCollectionViewCell.self, forCellWithReuseIdentifier: CarouselCollectionViewCell.cellId)
        collection.backgroundColor = .clear
        collection.translatesAutoresizingMaskIntoConstraints = false
        return collection
    }()
    
    private lazy var pageControl: NamesCustomPageControl = {
        let names = playersData.map { $0.name }
        let pageControl = NamesCustomPageControl(names: names)
        pageControl.pageIndicatorTintColor = UIColor.clear
        pageControl.currentPageIndicatorTintColor = UIColor.clear
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        return pageControl
    }()
    
    private lazy var plusOneButton: RoundButton = {
        let button = RoundButton(number: 1, toPlus: true, size: Constants.mainCalcButtonSize)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(calculationButtonPressed(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var leftArrowButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "previousEnd"), for: .normal)
        button.addTarget(self, action: #selector(leftArrowButtonPressed), for: .touchUpInside)
        return button
    }()
    
    private lazy var rightArrowButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "next"), for: .normal)
        button.addTarget(self, action: #selector(rightArrowButtonPressed), for: .touchUpInside)
        return button
    }()
    
    private lazy var undoButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "undo"), for: .normal)
        button.addTarget(self, action: #selector(undoButtonPressed), for: .touchUpInside)
        return button
    }()
    
    private lazy var minusTenButton: RoundButton = {
        let button = RoundButton(number: 10, toPlus: false, size: Constants.calcButtonSize)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(calculationButtonPressed(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var minusFiveButton: RoundButton = {
        let button = RoundButton(number: 5, toPlus: false, size: Constants.calcButtonSize)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(calculationButtonPressed(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var minusOneButton: RoundButton = {
        let button = RoundButton(number: 1, toPlus: false, size: Constants.calcButtonSize)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(calculationButtonPressed(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var plusFiveButton: RoundButton = {
        let button = RoundButton(number: 5, toPlus: true, size: Constants.calcButtonSize)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(calculationButtonPressed(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var plusTenButton: RoundButton = {
        let button = RoundButton(number: 10, toPlus: true, size: Constants.calcButtonSize)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(calculationButtonPressed(_:)), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Properties
    
    private var pages = 1
    private var playersData = [Player]()
    private var currentPage = 0 {
        didSet {
            GameSaver().currentGame?.turns.last?.currentPlayer
            //pageControl.currentPage = currentPage
        }
    }
    private var currentPlayer = 0
    public weak var delegate: CarouselViewDelegate?
    
    // MARK: - Initializers
    
    init(players: [Player], currentPage: Int) {
        super.init(frame: .zero)
        self.pages = players.count
        self.playersData = players
        self.currentPage = currentPage
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setups
    
    func setupUI() {
        backgroundColor = .clear
        setupCollectionView()
        setupPageControl()
        setupButtons()
        setupCalculationButtons()
    }
    
    func setupCollectionView() {
        addSubview(carouselCollectionView)
        
        NSLayoutConstraint.activate([
            carouselCollectionView.topAnchor.constraint(equalTo: topAnchor),
            carouselCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            carouselCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            //carouselCollectionView.heightAnchor.constraint(equalToConstant: Constants.collectionHeight)
        ])
    }
    
    func setupPageControl() {
        pageControl.numberOfPages = pages
        addSubview(pageControl)
        
        NSLayoutConstraint.activate([
            //pageControl.topAnchor.constraint(equalTo: carouselCollectionView.bottomAnchor, constant: 16),
            pageControl.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 10),
            pageControl.centerXAnchor.constraint(equalTo: centerXAnchor),
            pageControl.widthAnchor.constraint(equalToConstant: 300),
            pageControl.heightAnchor.constraint(equalToConstant: 25)
        ])
    }
    
    func setupButtons() {
        let arrowXAnchor = UIScreen.main.bounds.width / 4
        
        addSubview(plusOneButton)
        addSubview(leftArrowButton)
        addSubview(rightArrowButton)
        
        
        NSLayoutConstraint.activate([
            plusOneButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            plusOneButton.topAnchor.constraint(equalTo: carouselCollectionView.bottomAnchor, constant: -20),
            
            leftArrowButton.centerYAnchor.constraint(equalTo: plusOneButton.centerYAnchor),
            leftArrowButton.trailingAnchor.constraint(equalTo: leadingAnchor, constant: arrowXAnchor),
            
            rightArrowButton.centerYAnchor.constraint(equalTo: plusOneButton.centerYAnchor),
            rightArrowButton.leadingAnchor.constraint(equalTo: trailingAnchor, constant: -arrowXAnchor)
        ])
    }
    
    func setupCalculationButtons() {
        let spacing = Constants.screenWidth * 0.01
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .equalCentering
        stackView.alignment = .center
        stackView.spacing = 10.0
        
        stackView.addArrangedSubview(minusTenButton)
        stackView.addArrangedSubview(minusFiveButton)
        stackView.addArrangedSubview(minusOneButton)
        stackView.addArrangedSubview(plusFiveButton)
        stackView.addArrangedSubview(plusTenButton)
        
        addSubview(stackView)
        addSubview(undoButton)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.topAnchor.constraint(equalTo: plusOneButton.bottomAnchor, constant: 22),
            stackView.bottomAnchor.constraint(equalTo: pageControl.topAnchor, constant: -20),
            
            undoButton.topAnchor.constraint(equalTo: minusTenButton.bottomAnchor, constant: 20),
            undoButton.centerXAnchor.constraint(equalTo: minusTenButton.centerXAnchor)
        ])
    }
    
    // MARK: - UICollectionViewDataSource
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return playersData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CarouselCollectionViewCell.cellId, for: indexPath) as? CarouselCollectionViewCell else { return UICollectionViewCell() }
        let name = playersData[indexPath.row].name
        let score = playersData[indexPath.row].score
        cell.configure(name: name, score: score)
        return cell
    }
    
    public func configure(with data: [Player]) {
        let carouselLayout = UICollectionViewFlowLayout()
        let width = UIScreen.main.bounds.width * 0.68
        let height = width * 1.176
        let cellPadding = (UIScreen.main.bounds.width - width) / 2
        carouselLayout.scrollDirection = .horizontal
        carouselLayout.itemSize = CGSize(width: width, height: height)
        carouselLayout.minimumLineSpacing = UIScreen.main.bounds.width - width
        carouselLayout.sectionInset = UIEdgeInsets(top: 0, left: cellPadding, bottom: 0, right: cellPadding)
        carouselCollectionView.isPagingEnabled = true
        carouselCollectionView.collectionViewLayout = carouselLayout
        
        playersData = data
        carouselCollectionView.reloadData()
    }
    
    // MARK: - Helpers
    
    func getCurrentPage() -> Int {
        let visibleRect = CGRect(origin: carouselCollectionView.contentOffset, size: carouselCollectionView.bounds.size)
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        if let visibleIndexPath = carouselCollectionView.indexPathForItem(at: visiblePoint) {
            return visibleIndexPath.row
        }
        return currentPage
        
        
    }
    
    // MARK: - UICollectionView Delegate
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        currentPage = getCurrentPage()
        currentPlayer = currentPage
        delegate?.changeTurn(Turn(playerName: playersData[currentPlayer].name, scoreChanged: "0", lastScore: playersData[currentPlayer].score, currentPlayer: currentPlayer))
        updateButtons()
    }
        
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        currentPage = getCurrentPage()
        currentPlayer = currentPage
        //delegate?.changeTurn(Turn(playerName: playersData[currentPlayer].name, scoreChanged: "0", currentPlayer: currentPlayer))
        updateButtons()
    }
        
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        currentPage = getCurrentPage()
        currentPlayer = currentPage
        //delegate?.changeTurn(Turn(playerName: playersData[currentPlayer].name, scoreChanged: "0", currentPlayer: currentPlayer))
        updateButtons()
    }
    
    // MARK: - Buttons
    
    @objc private func calculationButtonPressed(_ sender: RoundButton) {
        guard let plusOrMinus = sender.operation else { return }
        guard let number = sender.number else { return }
        let score = playersData[currentPlayer].score
        var scoreChanged = ""
        if plusOrMinus {
            playersData[currentPlayer].score = score + number
            scoreChanged = "+\(number)"
        } else {
            playersData[currentPlayer].score = score - number
            scoreChanged = "-\(number)"
        }
        playersData[currentPlayer].score = plusOrMinus ? score + number : score - number
        let indexPath = IndexPath(item: currentPlayer, section: 0)
        carouselCollectionView.reloadItems(at: [indexPath])
        delegate?.changeTurn(Turn(playerName: playersData[currentPlayer].name, scoreChanged: scoreChanged, lastScore: playersData[currentPlayer].score, currentPlayer: currentPlayer))
        
        let row = indexPath.row == playersData.count - 1 ? 0 : currentPage + 1
        currentPlayer = row
        carouselCollectionView.scrollToItem(at: IndexPath(row: row, section: 0), at: .centeredHorizontally, animated: true)
        updateButtons()
    }
    
    @objc private func leftArrowButtonPressed() {
        guard !(playersData.isEmpty) else { return }
        let row = currentPage == 0 ? playersData.count - 1 : currentPage - 1
        let indexPath = IndexPath(row: row, section: 0)
        currentPlayer = row
        delegate?.changeTurn(Turn(playerName: playersData[currentPlayer].name, scoreChanged: "0", lastScore: playersData[currentPlayer].score, currentPlayer: currentPlayer))
        carouselCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        updateButtons()
    }
    
    @objc private func rightArrowButtonPressed() {
        guard !(playersData.isEmpty) else { return }
        let row = currentPage == playersData.count - 1 ? 0 : currentPage + 1
        let indexPath = IndexPath(row: row, section: 0)
        currentPlayer = row
        delegate?.changeTurn(Turn(playerName: playersData[currentPlayer].name, scoreChanged: "0", lastScore: playersData[currentPlayer].score, currentPlayer: currentPlayer))
        carouselCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        updateButtons()
    }
    
    private func updateButtons() {
        if (playersData.count == 1) {
            leftArrowButton.setImage(UIImage(named: "previousEnd"), for: .normal)
            rightArrowButton.setImage(UIImage(named: "nextEnd"), for: .normal)
        } else {
            let leftImage = currentPlayer == 0 ? "previousEnd" : "previous"
            let rightImage = currentPlayer == playersData.count - 1 ? "nextEnd" : "next"
            
            leftArrowButton.setImage(UIImage(named: leftImage), for: .normal)
            rightArrowButton.setImage(UIImage(named: rightImage), for: .normal)
        }
    }
    
    @objc private func undoButtonPressed() {
        guard let turn = delegate?.undoLastTurn() else { return }
        playersData[turn.currentPlayer].score -= turn.lastScore
        carouselCollectionView.reloadItems(at: [IndexPath(row: currentPlayer, section: 0)])
    }
}
