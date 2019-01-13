//
//  DeviceHomeViewController.swift
//  Dexcom Follower
//
//  Created by James Furlong on 2/1/19.
//  Copyright © 2019 James Furlong. All rights reserved.
//

import RxSwift
import SwiftCharts

class DeviceHomeViewController: UIViewController {
    private let disposeBag: DisposeBag = DisposeBag()
    private let viewModel: DeviceHomeViewModel = DeviceHomeViewModel()
    private var buttonArray = [UIButton]()
    var highlightViewLocation = NSLayoutConstraint()
    
    private let graphHourViewHeight: CGFloat = 40.0
    
    // MARK: UI
    
    private let infoView: UIView = {
        let view: UIView = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var profileImageView: UIImageView = {
        let imageView: UIImageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 8
        imageView.backgroundColor = Theme.Color.deviceHomeImageBackground
        imageView.image = UIImage.imageWithColor(
            color: Theme.Color.deviceHomeImageBackground,
            height: 80,
            width: 80
        )
        
        return imageView
    }()
    
    private lazy var lastUpdatedLabel: UILabel = {
        let label: UILabel = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Theme.Font.deviceHomeCellUnits
        label.textColor = Theme.Color.deviceHomeMainText
        label.text = "5min ago"
        
        return label
    }()
    
    private lazy var currentLevelLabel: UILabel = {
        let label: UILabel = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Theme.Font.deviceHomeCellMeasurement
        label.textColor = Theme.Color.deviceHomeMainText
        label.text = "7.1"
        
        return label
    }()
    
    private lazy var unitsLabel: UILabel = {
        let label: UILabel = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Theme.Font.deviceHomeCellUnits
        label.textColor = Theme.Color.deviceHomeMainText
        label.text = "mml/"
        
        return label
    }()
    
    private let graphButtonView: UIView = {
        let view: UIView = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let graphHourView: UIView = {
        let view: UIView = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.Color.deviceHomeNavBarTopColor
        view.layer.cornerRadius = 15
        
        return view
    }()
    
    private let graphButtonLabel: UILabel = {
        let label: UILabel = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.text = "3HR"
        
        return label
    }()
    
    private lazy var threeHourButton: UIButton = {
        let button: UIButton = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("3HR", for: .normal)
        button.setTitleColor(Theme.Color.deviceHomeNavBarTopColor, for: .normal)
        button.tag = 3
        
        button.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.viewModel.filterButtonTapped.onNext(3)
            })
            .disposed(by: disposeBag)
        
        return button
    }()
    
    private lazy var sixHourButton: UIButton = {
        let button: UIButton = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("6HR", for: .normal)
        button.setTitleColor(Theme.Color.deviceHomeNavBarTopColor, for: .normal)
        button.tag = 6
        
        button.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.viewModel.filterButtonTapped.onNext(6)
            })
            .disposed(by: disposeBag)
        
        return button
    }()
    
    private lazy var twelveHourButton: UIButton = {
        let button: UIButton = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("12HR", for: .normal)
        button.setTitleColor(Theme.Color.deviceHomeNavBarTopColor, for: .normal)
        button.tag = 12
        
        button.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.viewModel.filterButtonTapped.onNext(12)
            })
            .disposed(by: disposeBag)
        
        return button
    }()

    private lazy var twentyFourHourButton: UIButton = {
        let button: UIButton = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("24HR", for: .normal)
        button.setTitleColor(Theme.Color.deviceHomeNavBarTopColor, for: .normal)
        button.tag = 24
        
        button.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.viewModel.filterButtonTapped.onNext(24)
            })
            .disposed(by: disposeBag)
        
        return button
    }()
    
    private let graphView: UIView = {
        let view: UIView = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var egvsChart: LineChart = {
        let chartConfig = ChartConfigXY(
            xAxisConfig: ChartAxisConfig(from: 0, to: 24, by: 2),
            yAxisConfig: ChartAxisConfig(from: 0, to: 22, by: 2)
        )
        let chart: LineChart = LineChart(
            frame: CGRect(x: 0, y: 0, width: self.view.frame.width - 20, height: 500),
            chartConfig: chartConfig,
            xTitle: "Time",
            yTitle: "Level",
            line: (chartPoints: [(2.0, 2.0)], color: Theme.Color.deviceHomeMainText)
        )
        
        
        return chart
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        highlightViewLocation = setEqualSpaceConstraint(item: graphHourView, multiplier: 1/4)
        view.backgroundColor = .white
        
        view.addSubview(infoView)
        
        infoView.addSubview(profileImageView)
        infoView.addSubview(lastUpdatedLabel)
        infoView.addSubview(currentLevelLabel)
        infoView.addSubview(unitsLabel)
        
        view.addSubview(graphButtonView)
        
        graphButtonView.addSubview(threeHourButton)
        graphButtonView.addSubview(sixHourButton)
        graphButtonView.addSubview(twelveHourButton)
        graphButtonView.addSubview(twentyFourHourButton)
        graphButtonView.addSubview(graphHourView)
        
        graphHourView.addSubview(graphButtonLabel)
        
        view.addSubview(graphView)
        
        graphView.addSubview(egvsChart.view)
        
        buttonArray = [self.threeHourButton, self.sixHourButton, self.twelveHourButton, self.twentyFourHourButton]
        
        setupLayout()
        setupBinding()
    }
    
    // MARK: Layout
    
    private func setupLayout() {
        let topBarHeight = UIApplication.shared.statusBarFrame.size.height +
            (self.navigationController?.navigationBar.frame.height ?? 0.0)
        
        let graphViewCenterXConstraint: NSLayoutConstraint = graphHourView.centerXAnchor.constraint(equalTo: graphView.centerXAnchor, constant: (self.view.bounds.width) * 0.20 - ((self.view.bounds.width) / 2))
    
        viewModel.updateFilterView
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] filter in
                let center: CGFloat = {
                    let width = self?.view.bounds.width ?? 0.0
                    switch filter {
                        case 3: return ((width) * 0.20) - (width / 2)
                        case 6: return ((width) * 0.40) - (width / 2)
                        case 12: return ((width) * 0.60) - (width / 2)
                        default: return ((width) * 0.80) - (width / 2)
                    }
                }()
                graphViewCenterXConstraint.constant = center
                UIView.animate(
                    withDuration: 3.0,
                    delay: 0.0,
                    options: .curveEaseInOut,
                    animations: {
                        self?.view.setNeedsLayout()
                        self?.view.layoutIfNeeded()
                },
                    completion: nil
                )
            })
            .disposed(by: disposeBag)
        
        NSLayoutConstraint.activate([
            graphView.heightAnchor.constraint(equalToConstant: 500),
            graphView.leftAnchor.constraint(equalTo: view.leftAnchor),
            graphView.rightAnchor.constraint(equalTo: view.rightAnchor),
            graphView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            graphButtonView.heightAnchor.constraint(equalToConstant: 70),
            graphButtonView.leftAnchor.constraint(equalTo: view.leftAnchor),
            graphButtonView.rightAnchor.constraint(equalTo: view.rightAnchor),
            graphButtonView.bottomAnchor.constraint(equalTo: egvsChart.view.topAnchor),
            
            graphHourView.widthAnchor.constraint(equalToConstant: (view.frame.width - 20) / 5),
            graphHourView.heightAnchor.constraint(equalToConstant: 30),
            graphHourView.centerYAnchor.constraint(equalTo: graphButtonView.centerYAnchor),
            graphViewCenterXConstraint,
            graphButtonLabel.centerXAnchor.constraint(equalTo: graphHourView.centerXAnchor),
            graphButtonLabel.centerYAnchor.constraint(equalTo: graphHourView.centerYAnchor),
            threeHourButton.centerYAnchor.constraint(equalTo: graphButtonView.centerYAnchor),
            sixHourButton.centerYAnchor.constraint(equalTo: graphButtonView.centerYAnchor),
            twelveHourButton.centerYAnchor.constraint(equalTo: graphButtonView.centerYAnchor),
            twentyFourHourButton.centerYAnchor.constraint(equalTo: graphButtonView.centerYAnchor),
            
            infoView.leftAnchor.constraint(equalTo: view.leftAnchor),
            infoView.rightAnchor.constraint(equalTo: view.rightAnchor),
            infoView.bottomAnchor.constraint(equalTo: graphButtonView.topAnchor),
            infoView.topAnchor.constraint(equalTo: view.topAnchor, constant: topBarHeight),
            
            profileImageView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10),
            profileImageView.centerYAnchor.constraint(equalTo: infoView.centerYAnchor),
            lastUpdatedLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            lastUpdatedLabel.bottomAnchor.constraint(equalTo: currentLevelLabel.topAnchor, constant: -10),
            currentLevelLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            currentLevelLabel.centerYAnchor.constraint(equalTo: infoView.centerYAnchor),
            unitsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            unitsLabel.topAnchor.constraint(equalTo: currentLevelLabel.bottomAnchor, constant: 10)
        ])
        
        self.view.addConstraint(self.highlightViewLocation)
        self.view.addConstraint(setEqualSpaceConstraint(item: threeHourButton, multiplier: 2/5))
        self.view.addConstraint(setEqualSpaceConstraint(item: sixHourButton, multiplier: 4/5))
        self.view.addConstraint(setEqualSpaceConstraint(item: twelveHourButton, multiplier: 6/5))
        self.view.addConstraint(setEqualSpaceConstraint(item: twentyFourHourButton, multiplier: 8/5))
    }
    
    // MARK: Binding
    
    private func setupBinding() {
        
    }
    
    // MARK: Functions
    
    private func setEqualSpaceConstraint(item: UIView, multiplier: CGFloat) -> NSLayoutConstraint {
        return NSLayoutConstraint(
            item: item,
            attribute: .centerX,
            relatedBy: .equal,
            toItem: self.view,
            attribute: .centerX,
            multiplier: multiplier,
            constant: 0
        )
    }
    
    private func changeFilterButtonColor(filter: Int, multiplier: CGFloat) {
        highlightViewLocation = setEqualSpaceConstraint(item: graphHourView, multiplier: multiplier)
        DispatchQueue.main.async {
            UIView.animate(
                withDuration: 3.0,
                delay: 0.0,
                options: .curveEaseInOut,
                animations: {
//                    switch filter {
//                        case 3: self.threeHourButton.setTitleColor(.white, for: .normal)
//                        case 6: self.sixHourButton.setTitleColor(.white, for: .normal)
//                        case 12: self.twelveHourButton.setTitleColor(.white, for: .normal)
//                        default: self .twentyFourHourButton.setTitleColor(.white, for: .normal)
//                    }
//                    for button in self.buttonArray where button.tag != filter {
//                        button.setTitleColor(Theme.Color.deviceHomeMainText, for: .normal)
//                    }
//                    self.highlightViewLocation = self.setEqualSpaceConstraint(item: self.graphHourView, multiplier: multiplier)
                    self.view.layoutSubviews()
                    self.view.layoutIfNeeded()
            },
                completion: nil
            )
        }
    }
}
