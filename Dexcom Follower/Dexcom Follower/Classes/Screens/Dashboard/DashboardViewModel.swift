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
    private let disposeBag: DisposeBag = DisposeBag()
    
    // MARK: - Actions
    
    let viewDidAppear: PublishSubject<Void> = PublishSubject()
    let editTapped: PublishSubject<Void> = PublishSubject()
    
    // MARK: - Observables
    
    lazy var devicesSingle: Observable<DeviceResponse> = {
        viewDidAppear
//            .map { [weak self] _ in
//                let code: String = KeychainWrapper.shared[KeychainWrapper.authenticationCode] ?? ""
//                self?.apiClient.loginToken(authenticationCode: code) { (response: TokenResponse) in
//                    KeychainWrapper.shared[KeychainWrapper.authenticationToken] = response.accessToken
//                }
//                return
//            }
            .map { [weak self] token in
                let token: String = KeychainWrapper.shared[KeychainWrapper.authenticationToken] ?? ""
                let devices = self?.apiClient.getDevices(token: token) ?? DeviceResponse(devices: [Devices]())
                return devices
            }
            .asObservable()
    }()
    
    lazy var devicesArray: Observable<DeviceResponse> = {
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
    
    lazy var subjectsArray: Observable<[Subject]> = {
        let mockArray: [Subject] = [
            Subject(
                name: "Test Subject",
                measurement: "7.4",
                isActive: true
            ),
            Subject(
                name: "Second Subject",
                measurement: "---",
                isActive: false
            )
        ]
        
        return Observable.just(mockArray).asObservable()
    }()
}
