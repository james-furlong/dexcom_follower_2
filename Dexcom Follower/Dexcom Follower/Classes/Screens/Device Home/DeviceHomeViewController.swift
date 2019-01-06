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
    
    private lazy var threeHourButton: UIButton = {
        let button: UIButton = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("3HR", for: .normal)
        button.setTitleColor(Theme.Color.deviceHomeNavBarTopColor, for: .normal)
        
        button.rx.tap
            .bind(to: viewModel.threeHourButtonTapped)
            .disposed(by: disposeBag)
        
        return button
    }()
    
    private lazy var sixHourButton: UIButton = {
        let button: UIButton = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("6HR", for: .normal)
        button.setTitleColor(Theme.Color.deviceHomeNavBarTopColor, for: .normal)
        
        button.rx.tap
            .bind(to: viewModel.sixHourButtonTapped)
            .disposed(by: disposeBag)
        
        return button
    }()
    
    private lazy var twelveHourButton: UIButton = {
        let button: UIButton = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("12HR", for: .normal)
        button.setTitleColor(Theme.Color.deviceHomeNavBarTopColor, for: .normal)
        
        button.rx.tap
            .bind(to: viewModel.twelveHourButtonTapped)
            .disposed(by: disposeBag)
        
        return button
    }()

    private lazy var twentyFourHourButton: UIButton = {
        let button: UIButton = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("24HR", for: .normal)
        button.setTitleColor(Theme.Color.deviceHomeNavBarTopColor, for: .normal)
        
        button.rx.tap
            .bind(to: viewModel.twentyFourHourButtonTapped)
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
        
        graphButtonView.addSubview(graphHourView)
        graphButtonView.addSubview(threeHourButton)
        graphButtonView.addSubview(sixHourButton)
        graphButtonView.addSubview(twelveHourButton)
        graphButtonView.addSubview(twentyFourHourButton)
        
        view.addSubview(graphView)
        
        graphView.addSubview(egvsChart.view)
        
        setupLayout()
        setupBinding()
    }
    
    // MARK: Layout
    
    private func setupLayout() {
        let topBarHeight = UIApplication.shared.statusBarFrame.size.height +
            (self.navigationController?.navigationBar.frame.height ?? 0.0)
        
        NSLayoutConstraint.activate([
            graphView.heightAnchor.constraint(equalToConstant: 500),
            graphView.leftAnchor.constraint(equalTo: view.leftAnchor),
            graphView.rightAnchor.constraint(equalTo: view.rightAnchor),
            graphView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            graphButtonView.heightAnchor.constraint(equalToConstant: 70),
            graphButtonView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            graphButtonView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            graphButtonView.bottomAnchor.constraint(equalTo: egvsChart.view.topAnchor),
            
            graphHourView.widthAnchor.constraint(equalToConstant: (view.frame.width - 20) / 4),
            graphHourView.heightAnchor.constraint(equalToConstant: 30),
            graphHourView.centerYAnchor.constraint(equalTo: graphButtonView.centerYAnchor),
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
        self.view.addConstraint(setEqualSpaceConstraint(item: threeHourButton, multiplier: 1/4))
        self.view.addConstraint(setEqualSpaceConstraint(item: sixHourButton, multiplier: 3/4))
        self.view.addConstraint(setEqualSpaceConstraint(item: twelveHourButton, multiplier: 5/4))
        self.view.addConstraint(setEqualSpaceConstraint(item: twentyFourHourButton, multiplier: 7/4))
    }
    
    // MARK: Binding
    
    private func setupBinding() {
        viewModel.updateFilterView
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] filter in
                let buttonArray = [self?.threeHourButton ?? UIButton(),
                                   self?.sixHourButton ?? UIButton(),
                                   self?.twelveHourButton ?? UIButton(),
                                   self?.twentyFourHourButton ?? UIButton()
                ]
                let multiplier: Double = {
                    switch filter {
                        case 3: return 1/4
                        case 6: return 3/4
                        case 12: return 5/4
                        default: return 7/5
                    }
                }()
                UIView.animate(
                    withDuration: 0.6,
                    delay: 0.0,
                    options: [],
                    animations: {
                        switch filter {
                            case 3: self?.threeHourButton.setTitleColor(.white, for: .normal)
                            case 6: self?.sixHourButton.setTitleColor(.white, for: .normal)
                            case 12: self?.twelveHourButton.setTitleColor(.white, for: .normal)
                            default: self? .twentyFourHourButton.setTitleColor(.white, for: .normal)
                        }
                        for button in buttonArray where button.tag != filter {
                            button.setTitleColor(Theme.Color.deviceHomeMainText, for: .normal)
                        }
                },
                    completion: <#T##((Bool) -> Void)?##((Bool) -> Void)?##(Bool) -> Void#>
                )
            })
            .disposed(by: disposeBag)
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
}
