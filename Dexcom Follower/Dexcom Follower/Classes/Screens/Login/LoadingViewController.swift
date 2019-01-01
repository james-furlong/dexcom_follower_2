//
//  LoadingViewController.swift
//  Dexcom Follower
//
//  Created by James Furlong on 31/12/18.
//  Copyright © 2018 James Furlong. All rights reserved.
//

import RxSwift

class LoadingViewController: UIViewController {
    
    private let disposeBag: DisposeBag = DisposeBag()
    private let viewModel: LoadingViewModel = LoadingViewModel()
    
    // MARK: UI
    
    private let viewHolder: UIStackView = {
        let view: UIStackView = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.distribution = .equalSpacing
        view.alignment = .fill
        view.spacing = 0
    
        return view
    }()
    
    private let loadingMessage: UILabel = {
        let label: UILabel = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Theme.Font.logingMainText
        label.textColor = Theme.Color.loginWelcomeText
        label.textAlignment = .center
        label.text = "Loading you account..."
        label.numberOfLines = 0
        
        return label
    }()
    
    private lazy var indicatorView: UIActivityIndicatorView = {
        let view: UIActivityIndicatorView = UIActivityIndicatorView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.style = .gray
        view.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        view.center = CGPoint(x: self.view.bounds.size.width / 2, y: self.view.bounds.size.height / 2)
        
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        viewHolder.addSubview(loadingMessage)
        viewHolder.addSubview(indicatorView)
        
        view.addSubview(viewHolder)

        setupLayout()
        setupBinding()
    }
    
    // MARK: Layout
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            viewHolder.leftAnchor.constraint(equalTo: view.leftAnchor),
            viewHolder.rightAnchor.constraint(equalTo: view.rightAnchor),
            viewHolder.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            viewHolder.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            loadingMessage.topAnchor.constraint(equalTo: viewHolder.topAnchor),
            loadingMessage.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            loadingMessage.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            indicatorView.topAnchor.constraint(equalTo: loadingMessage.bottomAnchor),
            indicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            indicatorView.bottomAnchor.constraint(equalTo: viewHolder.bottomAnchor)
        ])
    }
    
    // MARK: Binding
    
    private func setupBinding() {
        self.rx.viewDidAppear
            .bind(to: viewModel.viewDidAppear)
            .disposed(by: disposeBag)
        
        viewModel.authenticationToken
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                self?.indicatorView.startAnimating()
            })
            .disposed(by: disposeBag)
        
        viewModel.viewDashboard
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                UIView.animate(
                    withDuration: 0.6,
                    animations: {
                        self?.indicatorView.isHidden = true
                },
                    completion: { _ in
                        let viewController: DashboardViewController = DashboardViewController()
                        self?.present(viewController, animated: true, completion: nil)
                })
            })
            .disposed(by: disposeBag)
        
        viewModel.viewErrorMessage
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] alert in
                self?.present(alert, animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
    }
}
