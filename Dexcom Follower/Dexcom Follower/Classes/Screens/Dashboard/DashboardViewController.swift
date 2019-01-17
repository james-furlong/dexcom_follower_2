//
//  DashboardViewController.swift
//  Dexcom Follower
//
//  Created by James Furlong on 11/11/18.
//  Copyright © 2018 James Furlong. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class DashboardViewController: UIViewController {
    private let disposeBag: DisposeBag = DisposeBag()
    private let viewModel: DashboardViewModel = DashboardViewModel()
    
    // MARK: - UI
    
    private lazy var editButton: UIButton = {
        let button: UIButton = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Edit", for: .normal)
        button.titleLabel?.textColor = Theme.Color.dashboardNavBarTextColor
        button.titleLabel?.font = Theme.Font.dashboardNavBarEditButtonFont
        
        button.rx.tap
            .bind(to: viewModel.editTapped)
            .disposed(by: disposeBag)
        
        return button
    }()
    
    private lazy var tableView: UITableView = {
        let cellType = SubjectTableViewCell.self
        let resuseIdentifier = SubjectTableViewCell.defaultReuseIdentifier
        
        let tableView: UITableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.rowHeight = 95
        
        tableView.register(view: cellType)

        // Datasource
        
        viewModel.userCellArray
            .bind(to: tableView.rx.items(cellIdentifier: resuseIdentifier, cellType: cellType)) { _, item, cell in
                cell.update(with: item)
            }
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .bind(to: viewModel.cellTapped)
            .disposed(by: disposeBag)
        
        return tableView
    }()
    
    private let loadingIndicator: UIActivityIndicatorView = {
        let indicator: UIActivityIndicatorView = UIActivityIndicatorView()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.style = .whiteLarge
        indicator.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        indicator.color = .black
        indicator.startAnimating()
        
        return indicator
    }()
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Dexcom"
        view.backgroundColor = .white

        view.addSubview(editButton)
        view.addSubview(tableView)
        
        setupLayout()
        setupBinding()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        viewModel.viewDidAppear.onNext(())
    }
    
    // MARK: - Layout
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    // MARK: - Binding
    
    private func setupBinding() {
        self.rx.viewDidAppear
            .bind(to: viewModel.viewDidAppear)
            .disposed(by: disposeBag)
        
        viewModel.estimatedGlucoseValues
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { egvs in
                print("_)")
            })
            .disposed(by: disposeBag)
        
        viewModel.beginLoadingAnimation
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                self?.loadingIndicator.startAnimating()
            })
            .disposed(by: disposeBag)
        
        viewModel.stopLoadingAnimation
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                self?.loadingIndicator.stopAnimating()
            })
            .disposed(by: disposeBag)
        
        viewModel.viewUserDetail
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] egvs, user in
                let viewController: UIViewController = DeviceHomeViewController()
                self?.navigationController?.pushViewController(viewController, animated: true)
            })
            .disposed(by: disposeBag)
    }
}
