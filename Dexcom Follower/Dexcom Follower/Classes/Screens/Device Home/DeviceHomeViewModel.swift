//
//  DeviceHomeViewModel.swift
//  Dexcom Follower
//
//  Created by James Furlong on 2/1/19.
//  Copyright © 2019 James Furlong. All rights reserved.
//

import RxSwift
import RxCocoa

class DeviceHomeViewModel {
    private let disposeBag: DisposeBag = DisposeBag()
    
    // MARK: Actions
    let backTapped: PublishSubject<Void> = PublishSubject()
    let filterButtonTapped: PublishSubject<Int> = PublishSubject()
    let threeHourButtonTapped: PublishSubject<Void> = PublishSubject()
    let sixHourButtonTapped: PublishSubject<Void> = PublishSubject()
    let twelveHourButtonTapped: PublishSubject<Void> = PublishSubject()
    let twentyFourHourButtonTapped: PublishSubject<Void> = PublishSubject()
    
    // MARK: Observables
    
    lazy var userName: Observable<String> = {
        Observable.just("Test")
    }()
    
    lazy var currentFilter: Observable<Int> = {
        let relay: BehaviorRelay<Int> = BehaviorRelay(value: 3)
        
        filterButtonTapped
            .throttle(0.250, scheduler: ConcurrentDispatchQueueScheduler(qos: .background))
            .bind(to: relay)
            .disposed(by: disposeBag)
        
        return relay.asObservable()
    }()
    
    lazy var updateFilterView: Observable<Int> = {
        filterButtonTapped
            .throttle(0.250, scheduler: ConcurrentDispatchQueueScheduler(qos: .background))
            .asObservable()
    }()
    
    lazy var viewDashboard: Observable<Void> = {
        backTapped
            .throttle(0.250, scheduler: ConcurrentDispatchQueueScheduler(qos: .background))
            .asObservable()
    }()
}
