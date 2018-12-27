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
        label.text = "mmol/L"
        
        return label
    }()
    
    private let inactiveOverlay: UIView = {
        let view: UIView = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.Color.subjectCellInactiveOverlay
        view.isHidden = true
        
        return view
    }()
    
    private let inactiveLabel: UILabel = {
        let label: UILabel = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = Theme.Font.subjectCellError
        label.text = "NOT ACTIVE"
        label.isHidden = true
        
        return label
    }()
    
    // MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        self.contentView.addSubview(subjectImage)
        self.contentView.addSubview(subjectName)
        self.contentView.addSubview(measurementLabel)
        self.contentView.addSubview(unitsLabel)
        
        self.contentView.addSubview(inactiveOverlay)
        self.contentView.addSubview(inactiveLabel)
        
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
            inactiveOverlay.topAnchor.constraint(equalTo: contentView.topAnchor),
            inactiveOverlay.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            inactiveOverlay.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            inactiveOverlay.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            inactiveLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            inactiveLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        
        inactiveOverlay.frame = self.contentView.frame
    }
    
    // MARK: - Functions
    
    func update(with item: Subject) {
        self.subjectName.text = item.name
        self.measurementLabel.text = item.measurement
        let measurementDouble: Double = item.toDouble(from: item.measurement)
        switch measurementDouble {
            case _ where measurementDouble < 4.5 && measurementDouble >= 4.0:
                self.contentView.backgroundColor = (item.isActive ? Theme.Color.subjectCellOkBackground : .clear)
            case _ where measurementDouble > 7.5 && measurementDouble <= 8.0:
                self.contentView.backgroundColor = (item.isActive ? Theme.Color.subjectCellOkBackground : .clear)
            case _ where measurementDouble < 4.0 || measurementDouble > 8.0:
                self.contentView.backgroundColor = (item.isActive ? Theme.Color.subjectCellBadBackground : .clear)
            default :
                self.contentView.backgroundColor = Theme.Color.subjectCellGoodBackground
        }
        self.inactiveOverlay.isHidden = item.isActive
        self.inactiveLabel.isHidden = item.isActive
    }
}
