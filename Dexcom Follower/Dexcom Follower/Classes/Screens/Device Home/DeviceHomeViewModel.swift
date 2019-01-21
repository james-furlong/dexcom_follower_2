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
        var filter: Int = 3
        
        retrieveData
            .withLatestFrom(authClient.accessToken())
            .subscribe(onNext: { [weak self] token in
                self?.apiClient.getEgvs(token: token, complete: { response in
                    // Data is coming in as US values
                    guard let reducedData = self?.reduceDataToTimePeriod(of: filter, data: response) else { return }
                    guard var data = self?.convertIntoData(from: reducedData, interval: filter) else { return }
                    relay.accept(data)
                })
            })
            .disposed(by: disposeBag)
        
        currentFilter
            .subscribe(onNext: { newFilter in
                filter = newFilter
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
    
    private func convertIntoData(from response: EgvResponse, interval: Int) -> [CGPoint] {
        var data: [CGPoint] = [CGPoint]()
        for event in response.egvs {
            let tmp: CGPoint = CGPoint(x: getDisplayTime(for: event.displayTime), y: Double(event.value))
            data.append(tmp)
        }
        for i in 0..<data.count {
            data[i].x -= (24.0 - CGFloat(interval))
        }
        let finalData = data.filter { $0.x > 0.0 }
        return finalData
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
    
    private func reduceDataToTimePeriod(of time: Int, data: EgvResponse) -> EgvResponse {
        let value = time - (2 * time)
        let date = data.egvs[data.egvs.count - 1].systemTime
        guard let compareDateTime = Calendar.current.date(
            byAdding: .hour,
            value: value,
            to: date
        ) else { return data }
        let workingData = data.egvs
//        let tmp = workingData[0].systemTime
        #warning ("TODO: Fix data not being filtered correctly")
        let reducedData = workingData.filter { (dataPoint: EGVS) -> Bool in
            dataPoint.systemTime > compareDateTime
        }
        var returnData = data
        returnData.egvs = reducedData
        return returnData
    }
    
    private func debugDate() -> Date {
        var dateComponents = DateComponents()
        dateComponents.year = 2015
        dateComponents.month = 6
        dateComponents.day = 1
        dateComponents.timeZone = TimeZone(abbreviation: "UTC")
        dateComponents.hour = 8
        dateComponents.minute = 30
        
        let userCalendar = Calendar.current
        guard let date = userCalendar.date(from: dateComponents) else { return Date() }
        return date
    }
}
