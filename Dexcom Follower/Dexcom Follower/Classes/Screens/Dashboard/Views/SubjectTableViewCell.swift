//
//  SubjectTableViewCell.swift
//  Dexcom Follower
//
//  Created by James Furlong on 8/12/18.
//  Copyright © 2018 James Furlong. All rights reserved.
//

import RxSwift
import RxCocoa

class SubjectTableViewCell: UITableViewCell {
    private let disposeBag: DisposeBag = DisposeBag()
    
    // MARK: - UI
    
    private lazy var subjectImage: UIImageView = {
        let imageView: UIImageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = Theme.Color.subjectCellImageBackground
        imageView.layer.cornerRadius = 8
        
        return imageView
    }()
    
    private lazy var subjectName: UILabel = {
        let label: UILabel = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.Color.subjectCellTextColor
        label.font = Theme.Font.subjectCellName
        label.textAlignment = .center
        label.isHidden = true
        
        return label
    }()
    
    private lazy var measurementLabel: UILabel = {
        let label: UILabel = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.Color.subjectCellTextColor
        label.font = Theme.Font.subjectCellMeasurement
        label.text = "---"
        
        return label
    }()
    
    private let unitsLabel: UILabel = {
        let label: UILabel = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.Color.subjectCellUnits
        label.font = Theme.Font.subjectCellUnits
        
        return label
    }()
    
    private lazy var trendImageView: UIImageView = {
        let imageView: UIImageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    // MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        self.contentView.addSubview(subjectImage)
        self.contentView.addSubview(subjectName)
        self.contentView.addSubview(measurementLabel)
        self.contentView.addSubview(unitsLabel)
        self.contentView.addSubview(trendImageView)
        
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Layout
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            subjectImage.widthAnchor.constraint(equalToConstant: 70),
            subjectImage.heightAnchor.constraint(equalToConstant: 70),
            subjectImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            subjectImage.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10),
            subjectName.widthAnchor.constraint(equalTo: subjectImage.widthAnchor),
            subjectName.centerXAnchor.constraint(equalTo: subjectImage.centerXAnchor),
            subjectName.topAnchor.constraint(equalTo: subjectImage.bottomAnchor, constant: 2),
            measurementLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 30),
            measurementLabel.leftAnchor.constraint(equalTo: subjectImage.rightAnchor, constant: 30),
            unitsLabel.topAnchor.constraint(equalTo: measurementLabel.bottomAnchor, constant: 10),
            unitsLabel.leftAnchor.constraint(equalTo: subjectImage.rightAnchor, constant: 30),
            trendImageView.widthAnchor.constraint(equalToConstant: 100),
            trendImageView.heightAnchor.constraint(equalToConstant: 100),
            trendImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            trendImageView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -20)
        ])
    }
    
    // MARK: - Functions
    
    func update(with item: User) {
        self.subjectImage.image = item.userImage
        self.subjectName.text = item.name
        self.unitsLabel.text = item.units
        self.measurementLabel.text = String(format: "%.1f", item.value)
        
        
        switch item.value {
            case _ where item.value < 4.5 && item.value >= 4.0:
                self.contentView.backgroundColor = Theme.Color.subjectCellOkBackground
            case _ where item.value > 7.5 && item.value <= 8.0:
                self.contentView.backgroundColor = Theme.Color.subjectCellOkBackground
            case _ where item.value < 4.0 || item.value > 8.0:
                self.contentView.backgroundColor = Theme.Color.subjectCellBadBackground
            default :
                self.contentView.backgroundColor = Theme.Color.subjectCellGoodBackground
        }
    }
}
