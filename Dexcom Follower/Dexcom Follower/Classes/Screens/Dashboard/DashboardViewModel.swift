//
//  DashboardViewModel.swift
//  Dexcom Follower
//
//  Created by James Furlong on 11/11/18.
//  Copyright © 2018 James Furlong. All rights reserved.
//

import RxSwift

class DashboardViewModel: ApiClientInjected {
    private let disposeBag: DisposeBag = DisposeBag()
    
    // MARK: - Actions
    
    let editTapped: PublishSubject<Void> = PublishSubject()
    
    // MARK: - Observables
    
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
