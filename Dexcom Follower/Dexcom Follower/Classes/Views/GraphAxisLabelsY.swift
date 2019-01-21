//
//  GraphAxisLabelsY.swift
//  Dexcom Follower
//
//  Created by James Furlong on 19/1/19.
//  Copyright © 2019 James Furlong. All rights reserved.
//

import UIKit

class GraphAxisLabelsY: UIView {
    
    private let firstLabel: UILabel = {
        let label: UILabel = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Theme.Font.deviceHomeGraphLabel
        label.textColor = Theme.Color.deviceHomeGraphLabel
        label.text = "Graph.Y.Label.One.Mml".localized
        
        return label
    }()
    
    private let secondLabel: UILabel = {
        let label: UILabel = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Theme.Font.deviceHomeGraphLabel
        label.textColor = Theme.Color.deviceHomeGraphLabel
        label.text = "Graph.Y.Label.Two.Mml".localized
        
        return label
    }()
    
    private let thirdLabel: UILabel = {
        let label: UILabel = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Theme.Font.deviceHomeGraphLabel
        label.textColor = Theme.Color.deviceHomeGraphLabel
        label.text = "Graph.Y.Label.Three.Mml".localized
        
        return label
    }()
    
    private let forthLabel: UILabel = {
        let label: UILabel = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Theme.Font.deviceHomeGraphLabel
        label.textColor = Theme.Color.deviceHomeGraphLabel
        label.text = "Graph.Y.Label.Four.Mml".localized
        
        return label
    }()
    
    private let fifthLabel: UILabel = {
        let label: UILabel = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Theme.Font.deviceHomeGraphLabel
        label.textColor = Theme.Color.deviceHomeGraphLabel
        label.text = "Graph.Y.Label.Five.Mml".localized
        
        return label
    }()
    
    private let sixthLabel: UILabel = {
        let label: UILabel = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Theme.Font.deviceHomeGraphLabel
        label.textColor = Theme.Color.deviceHomeGraphLabel
        label.text = "Graph.Y.Label.Six.Mml".localized
        
        return label
    }()
    
    private let seventhLabel: UILabel = {
        let label: UILabel = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Theme.Font.deviceHomeGraphLabel
        label.textColor = Theme.Color.deviceHomeGraphLabel
        label.text = "Graph.Y.Label.Seven.Mml".localized
        
        return label
    }()
    
    private let eighthLabel: UILabel = {
        let label: UILabel = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Theme.Font.deviceHomeGraphLabel
        label.textColor = Theme.Color.deviceHomeGraphLabel
        label.text = "Graph.Y.Label.Eight.Mml".localized
        
        return label
    }()
    
    private let ninthLabel: UILabel = {
        let label: UILabel = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Theme.Font.deviceHomeGraphLabel
        label.textColor = Theme.Color.deviceHomeGraphLabel
        label.text = "Graph.Y.Label.Nine.Mml".localized
        
        return label
    }()
    
    private let tenthLabel: UILabel = {
        let label: UILabel = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Theme.Font.deviceHomeGraphLabel
        label.textColor = Theme.Color.deviceHomeGraphLabel
        label.text = "Graph.Y.Label.Ten.Mml".localized
        
        return label
    }()
    
    private let eleventhLabel: UILabel = {
        let label: UILabel = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Theme.Font.deviceHomeGraphLabel
        label.textColor = Theme.Color.deviceHomeGraphLabel
        label.text = "Graph.Y.Label.Eleven.Mml".localized
        
        return label
    }()
    
    // MARK: - Initialiazers
    
    init(minY: CGFloat, maxY: CGFloat, width: CGFloat, height: CGFloat) {
        let frame = CGRect(x: 0, y: 0, width: width, height: height)
        super.init(frame: frame)
        
        self.addSubview(firstLabel)
        self.addSubview(secondLabel)
        self.addSubview(thirdLabel)
        self.addSubview(forthLabel)
        self.addSubview(fifthLabel)
        self.addSubview(sixthLabel)
        self.addSubview(seventhLabel)
        self.addSubview(eighthLabel)
        self.addSubview(ninthLabel)
        self.addSubview(tenthLabel)
        self.addSubview(eleventhLabel)
        
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - Layout
    
    private func setupLayout() {
        let difference = self.frame.height / 11 - (2 * self.frame.height)
        
        NSLayoutConstraint.activate([
            firstLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            firstLabel.rightAnchor.constraint(equalTo: self.rightAnchor),
            secondLabel.rightAnchor.constraint(equalTo: self.rightAnchor),
            secondLabel.bottomAnchor.constraint(equalTo: firstLabel.bottomAnchor, constant: difference),
            thirdLabel.rightAnchor.constraint(equalTo: self.rightAnchor),
            thirdLabel.bottomAnchor.constraint(equalTo: secondLabel.bottomAnchor, constant: difference),
            forthLabel.rightAnchor.constraint(equalTo: self.rightAnchor),
            forthLabel.bottomAnchor.constraint(equalTo: thirdLabel.bottomAnchor, constant: difference),
            fifthLabel.rightAnchor.constraint(equalTo: self.rightAnchor),
            fifthLabel.bottomAnchor.constraint(equalTo: forthLabel.bottomAnchor, constant: difference),
            sixthLabel.rightAnchor.constraint(equalTo: self.rightAnchor),
            sixthLabel.bottomAnchor.constraint(equalTo: fifthLabel.bottomAnchor, constant: difference),
            seventhLabel.rightAnchor.constraint(equalTo: self.rightAnchor),
            seventhLabel.bottomAnchor.constraint(equalTo: sixthLabel.bottomAnchor, constant: difference),
            eighthLabel.rightAnchor.constraint(equalTo: self.rightAnchor),
            eighthLabel.bottomAnchor.constraint(equalTo: seventhLabel.bottomAnchor, constant: difference),
            ninthLabel.rightAnchor.constraint(equalTo: self.rightAnchor),
            ninthLabel.bottomAnchor.constraint(equalTo: eighthLabel.bottomAnchor, constant: difference),
            tenthLabel.rightAnchor.constraint(equalTo: self.rightAnchor),
            tenthLabel.bottomAnchor.constraint(equalTo: ninthLabel.bottomAnchor, constant: difference),
            eleventhLabel.rightAnchor.constraint(equalTo: self.rightAnchor),
            eleventhLabel.bottomAnchor.constraint(equalTo: tenthLabel.bottomAnchor, constant: difference)
        ])
    }
}
