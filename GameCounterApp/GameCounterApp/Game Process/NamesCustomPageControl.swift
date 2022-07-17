//
//  NamesCustomPageControl.swift
//  GameCounterApp
//
//  Created by Nadezhda Zenkova on 30.08.2021.
//

import UIKit

final class NamesCustomPageControl: UIPageControl {

    private var names: [String]?
    private var dotSubview: UIImageView?

    override var numberOfPages: Int {
        didSet {
            updateDotsForTurn()
        }
    }

    override var currentPage: Int {
        didSet {
            updateDotsForTurn()
            
        }
    }
    
    override init(frame: CGRect) {
            super.init(frame: frame)
        
    }
    
    public func setNames(names: [String]) {
        self.numberOfPages = names.count
        self.names = names
        setDots()
    }
    
    convenience init(names: [String]) {
        self.init(frame: .zero)
        self.numberOfPages = names.count
        self.names = names
        setDots()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if #available(iOS 14.0, *) {
            defaultConfigurationForiOS14AndAbove()
        } else {
            pageIndicatorTintColor = .clear
            currentPageIndicatorTintColor = .clear
            clipsToBounds = false
        }
        setDots()
    }
    
    private func defaultConfigurationForiOS14AndAbove() {
        if #available(iOS 14.0, *) {
            guard let names = names, !names.isEmpty else { return }
            let letters = names.map { String($0.prefix(1)) }
            for index in 0..<numberOfPages {
                let font = UIFont(name: "Nunito-ExtraBold", size: 18.0) ?? .systemFont(ofSize: 17.0)
                let image = letters[index].image(withAttributes: [ .foregroundColor: UIColor.white, .font: font], size: CGSize(width: 15.0, height: 24.0))
                setIndicatorImage(image, forPage: index)
            }
            pageIndicatorTintColor = .gray
            currentPageIndicatorTintColor = .white
        }
    }

    private func setDots() {
        if #available(iOS 14.0, *) {
                defaultConfigurationForiOS14AndAbove()
            } else {
                defaultConfigurationLowerThaniOS14()
            }
    }
    
    private func updateDotsForTurn() {
        if #available(iOS 14.0, *) {
            pageIndicatorTintColor = .gray
            currentPageIndicatorTintColor = .white
        } else {
            defaultConfigurationLowerThaniOS14()
        }
    }
    
    private func defaultConfigurationLowerThaniOS14() {
        guard let names = names, !names.isEmpty else { return }
        let letters = names.map { String($0.prefix(1)) }
      
        var i = 0
        for view in self.subviews {
            var imageView = self.imageView(forSubview: view)
            if imageView == nil {
                let font = UIFont(name: "Nunito-ExtraBold", size: 18.0) ?? .systemFont(ofSize: 17.0)
                let image = letters[i].image(withAttributes: [ .foregroundColor: UIColor.white, .font: font], size: CGSize(width: 15.0, height: 24.0))
                imageView = UIImageView(image: image)
                imageView!.center = view.center
                view.addSubview(imageView!)
                view.clipsToBounds = false
            }
            if i == self.currentPage {
                imageView!.alpha = 1.0
            } else {
                imageView!.alpha = 0.5
            }
            i += 1
        }
    }

    fileprivate func imageView(forSubview view: UIView) -> UIImageView? {
        var dot: UIImageView?
        if let dotImageView = view as? UIImageView {
            dot = dotImageView
        } else {
            for foundView in view.subviews {
                if let imageView = foundView as? UIImageView {
                    dot = imageView
                    break
                }
            }
        }
        return dot
    }
}

extension String {
    
    /// Generates a `UIImage` instance from this string using a specified
    /// attributes and size.
    ///
    /// - Parameters:
    ///     - attributes: to draw this string with. Default is `nil`.
    ///     - size: of the image to return.
    /// - Returns: a `UIImage` instance from this string using a specified
    /// attributes and size, or `nil` if the operation fails.
    func image(withAttributes attributes: [NSAttributedString.Key: Any]? = nil, size: CGSize? = nil) -> UIImage? {
        let size = size ?? (self as NSString).size(withAttributes: attributes)
        return UIGraphicsImageRenderer(size: size).image { _ in
            (self as NSString).draw(in: CGRect(origin: .zero, size: size),
                                    withAttributes: attributes)
        }
    }
    
}
