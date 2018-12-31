//
//  DashboardViewModel.swift
//  Dexcom Follower
//
//  Created by James Furlong on 11/11/18.
//  Copyright © 2018 James Furlong. All rights reserved.
//

import RxSwift
import RxCocoa

class DashboardViewModel: ApiClientInjected {
    
    enum Trend: String {
        case doubleUp = "doubleUp"
        case singleUp = "singleUp"
        case fortyFiveUp = "fortyFiveUp"
        case flat = "flat"
        case fortyFiveDown = "fortyFiveDown"
        case singleDown = "singleDown"
        case doubleDown = "doubleDown"
        case none = "none"
        case notComputable = "notComputable"
        case rateOutOfRange = "rateOutOfRange"
    }
    
    private let disposeBag: DisposeBag = DisposeBag()
    
    // MARK: - Actions
    
    let viewDidAppear: PublishSubject<Void> = PublishSubject()
    let getLevels: PublishSubject<Void> = PublishSubject()
    let dataFinishedLoading: PublishSubject<Void> = PublishSubject()
    let dataFailedToLoad: PublishSubject<Void> = PublishSubject()
    let editTapped: PublishSubject<Void> = PublishSubject()
    
    // MARK: - Observables
    
    lazy var devicesSingle: Observable<DeviceResponse> = {
        Observable.just(())
            .map { [weak self] _ in
                let token: String = KeychainWrapper.shared[KeychainWrapper.authenticationToken] ?? ""
                var devices: DeviceResponse = DeviceResponse.defaultResponse()
                self?.apiClient.getDevices(token: token) { response in
                    devices = response
                }
                return devices
            }
            .asObservable()
    }()
    
    lazy var estimatedGlucoseValues: Observable<EgvResponse> = {
        let relay: BehaviorRelay<EgvResponse> = BehaviorRelay(value: EgvResponse.defaultResponse())
        
        viewDidAppear
            .subscribe(onNext: { [weak self] _ -> Void in
                guard let token: String = KeychainWrapper.shared[KeychainWrapper.authenticationToken] else {
                    return
                }
                self?.apiClient.getEgvs(token: token) { response in
                    relay.accept(response)
                    self?.getLevels.onNext(())
                }
            })
            .disposed(by: disposeBag)
        
        
        return relay.asObservable()
    }()
    
    lazy var devices: Observable<DeviceResponse> = {
        let relay: BehaviorRelay<DeviceResponse> = BehaviorRelay(value: DeviceResponse(devices: []))
        
        devicesSingle
            .subscribe(onNext: { device in
                relay.accept(device)
            })
            .disposed(by: disposeBag)
        
        return relay.asObservable()
    }()
    
    lazy var viewEditing: Observable<Void> = {
       Observable.never()
    }()
    
    lazy var userCellArray: Observable<[User]> = {
        let relay: BehaviorRelay<[User]> = BehaviorRelay(value: [User]())
        
        getLevels
            .withLatestFrom(estimatedGlucoseValues) { ($0, $1) }
            .map { [weak self] _, values in
                var userArray: [User] = [User]()
                guard let value = values.egvs.first else { return [User]() }
                let timeSinceLastUpdate: String = {
                    let lastUpdatedDateTime = value.displayTime
                    let currentDateTime = Date()
                    let minutes = Calendar.current.dateComponents([.minute], from: lastUpdatedDateTime, to: currentDateTime).minute
                    return String(format: "%dm ago", minutes ?? "?")
                }()
                let glucoseLevel = value.smoothedValue ?? value.realtimeValue
                let trendArrow: UIImage = self?.getTrendArrow(trend: value.trend ?? "") ?? UIImage()
                let units = values.unit
                let user: User = User(value: glucoseLevel, lastUpdated: timeSinceLastUpdate, units: units, trendArrow: trendArrow)
                userArray.append(user)
                self?.dataFinishedLoading.onNext(())
                return userArray
            }
            .bind(to: relay)
            .disposed(by: disposeBag)
        
        return relay.asObservable()
    }()
    
    lazy var beginLoadingAnimation: Observable<Void> = {
        viewDidAppear
            .asObserver()
    }()
    
    lazy var stopLoadingAnimation: Observable<Void> = {
        dataFinishedLoading
            .throttle(0.250, scheduler: ConcurrentDispatchQueueScheduler(qos: .background))
            .asObservable()
    }()
    
    // MARK: Internal functions
    
    private func getTrendArrow(trend: String) -> UIImage {
        var image: UIImage = UIImage()
        switch trend {
            case Trend.doubleUp.rawValue: image = #imageLiteral(resourceName: "arrow")
            case Trend.singleUp.rawValue: image = #imageLiteral(resourceName: "arrow")
            case Trend.fortyFiveUp.rawValue: image = #imageLiteral(resourceName: "arrow")
            case Trend.flat.rawValue: image = #imageLiteral(resourceName: "arrow")
            case Trend.fortyFiveDown.rawValue: image = #imageLiteral(resourceName: "arrow")
            case Trend.singleDown.rawValue: image = #imageLiteral(resourceName: "arrow")
            case Trend.doubleDown.rawValue: image = #imageLiteral(resourceName: "arrow")
            case Trend.none.rawValue: image = #imageLiteral(resourceName: "arrow")
            case Trend.notComputable.rawValue: image = #imageLiteral(resourceName: "arrow")
            case Trend.rateOutOfRange.rawValue: image = #imageLiteral(resourceName: "arrow")
            default: break
        }
        return image
    }
}
