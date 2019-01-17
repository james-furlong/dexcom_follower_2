//
//  DeviceHomeViewModel.swift
//  Dexcom Follower
//
//  Created by James Furlong on 2/1/19.
//  Copyright © 2019 James Furlong. All rights reserved.
//

import RxSwift
import RxCocoa
import Charts

class DeviceHomeViewModel: ApiClientInjected, AuthClientInjected {
    private let disposeBag: DisposeBag = DisposeBag()
    
    // MARK: Actions
    
    let backTapped: PublishSubject<Void> = PublishSubject()
    let viewDidAppear: PublishSubject<Void> = PublishSubject()
    let retrieveData: PublishSubject<Void> = PublishSubject()
    let filterButtonTapped: PublishSubject<Int> = PublishSubject()
    let threeHourButtonTapped: PublishSubject<Void> = PublishSubject()
    let sixHourButtonTapped: PublishSubject<Void> = PublishSubject()
    let twelveHourButtonTapped: PublishSubject<Void> = PublishSubject()
    let twentyFourHourButtonTapped: PublishSubject<Void> = PublishSubject()
    
    // MARK: Observables
    
    lazy var userName: Observable<String> = {
        Observable.just("Test")
    }()
    
    lazy var initialSetup: Observable<Void> = {
        let relay: BehaviorRelay<Void> = BehaviorRelay(value: ())
        
        viewDidAppear
            .map { [weak self] _ in
                self?.retrieveData.onNext(())
            }
            .subscribe()
            .disposed(by: disposeBag)
        
        return relay.asObservable()
    }()
    
    lazy var currentFilter: Observable<Int> = {
        let relay: BehaviorRelay<Int> = BehaviorRelay(value: 3)
        
        filterButtonTapped
            .throttle(0.250, scheduler: ConcurrentDispatchQueueScheduler(qos: .background))
            .bind(to: relay)
            .disposed(by: disposeBag)
        
        return relay.asObservable()
    }()
    
    lazy var data: Observable<[CGPoint]> = {
        let relay: BehaviorRelay<[CGPoint]> = BehaviorRelay(value: [CGPoint]())
        
        retrieveData
            .withLatestFrom(authClient.accessToken())
            .subscribe(onNext: { [weak self] token in
                self?.apiClient.getEgvs(token: token, complete: { response in
                    let data = self?.convertIntoData(from: response)
                    relay.accept(data ?? [CGPoint]())
                })
            })
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
    
    // MARK: Internal functions
    
    private func convertIntoData(from response: EgvResponse) -> [CGPoint] {
        var data: [CGPoint] = [CGPoint]()
        
        for event in response.egvs {
            let tmp: CGPoint = CGPoint(x: getDisplayTime(for: event.displayTime), y: Double(event.value))
            data.append(tmp)
        }
        
        return data
    }
        
    private func getDisplayTime(for time: Date) -> Double {
        let df: DateFormatter = DateFormatter()
        df.dateFormat = "HH:mm"
        let stringDate = df.string(from: time)
        let timeArray = stringDate.split(separator: ":")
        let decimalString = String(timeArray[1])
        let decimalDouble = Double(decimalString) ?? 0.0
        let decimalAmount = (decimalDouble / 60) * 100
        let totalString = String(format: "%@.%d", String(timeArray[0]), Int(decimalAmount))
        return Double(totalString) ?? 0.0
    }
}
