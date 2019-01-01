//
//  LoadingViewModel.swift
//  Dexcom Follower
//
//  Created by James Furlong on 31/12/18.
//  Copyright © 2018 James Furlong. All rights reserved.
//

import RxSwift

class LoadingViewModel: ApiClientInjected {
    private let disposeBag: DisposeBag = DisposeBag()
    
    // MARK: Actions
    let viewDidAppear: PublishSubject<Void> = PublishSubject()
    let dataFinishedLoading: PublishSubject<Void> = PublishSubject()
    let dataFailedToLoad: PublishSubject<Void> = PublishSubject()
    
    // MARK: Observables
    
    lazy var authenticationToken: Observable<Void> = {
        viewDidAppear
            .map { [weak self]_ in
                let code: String = KeychainWrapper.shared[KeychainWrapper.authenticationCode] ?? ""
                self?.apiClient.loginToken(authenticationCode: code, complete: { token in
                    KeychainWrapper.shared[KeychainWrapper.authenticationToken] = token.accessToken
                    self?.dataFinishedLoading.onNext(())
                })
            }
    }()
    
    lazy var viewDashboard: Observable<Void> = {
        dataFinishedLoading
            .throttle(0.250, scheduler: ConcurrentDispatchQueueScheduler(qos: .background))
            .asObservable()
    }()
    
    lazy var viewErrorMessage: Observable<UIAlertController> = {
        dataFailedToLoad
            .map { _ -> UIAlertController in
                let alert: UIAlertController = UIAlertController(title: "Error", message: "", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                return alert
            }
            .asObservable()
    }()
}
