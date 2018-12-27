//
//  LoginViewModel.swift
//  Dexcom Follower
//
//  Created by James Furlong on 9/12/18.
//  Copyright © 2018 James Furlong. All rights reserved.
//

import RxSwift
import RxCocoa

public class LoginViewModel {
    private let disposeBag: DisposeBag = DisposeBag()
    
    // MARK: - Actions
    
    let loginButtonTapped: PublishSubject<Void> = PublishSubject()
    
    // MARK: - Observables
    
    lazy var viewLogin: Observable<Void> = {
        loginButtonTapped
            .throttle(0.250, scheduler: ConcurrentDispatchQueueScheduler(qos: .background))
            .asObservable()
    }()
}
