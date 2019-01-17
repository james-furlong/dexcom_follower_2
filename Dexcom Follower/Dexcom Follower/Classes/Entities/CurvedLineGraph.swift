//
//  CurvedLineGraph.swift
//  Dexcom Follower
//
//  Created by James Furlong on 18/1/19.
//  Copyright © 2019 James Furlong. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class CurvedLineGraph: UIView {
    private let disposeBag: DisposeBag = DisposeBag()
    
    // MARK - Properties
    
    var data: [CGPoint] = []
    var lineColor: UIColor = .blue
    var background: [UIColor] = [.black, .white]
    var axisColor: UIColor = .white
    
    // MARK - UI
    
    lazy var backgroundView: GradientView = {
        let view: GradientView = GradientView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.colors = background
        view.startPoint = CGPoint(x: 0.5, y: 0)
        view.endPoint = CGPoint(x: 0.5, y: 1)
        view.gradientType = .linear
        
        return view
    }()
    
    
    
}


