//
//  Theme+Dashboard.swift
//  Dexcom Follower
//
//  Created by James Furlong on 11/11/18.
//  Copyright © 2018 James Furlong. All rights reserved.
//

import UIKit.UIColor

extension Theme.Color {
    
    // Dashboard
    static let dashboardNavBarTopColor: UIColor = .pickledBluewood
    static let dashboardNavBarBottomColor: UIColor = .persianGreen
    static let dashboardNavBarTextColor: UIColor = .halfBaked
    static let dashboardFooterBarBackgroundColor: UIColor = .pickledBluewood
    static let dashboardFooterTextColor: UIColor = .halfBaked
    
    // Subject cell
    static let subjectCellGoodBackground: UIColor = UIColor.green.withAlphaComponent(0.40)
    static let subjectCellOkBackground: UIColor = UIColor.yellow.withAlphaComponent(0.40)
    static let subjectCellBadBackground: UIColor = UIColor.red.withAlphaComponent(0.40)
    static let subjectCellImageBackground: UIColor = .pickledBluewood
    static let subjectCellTextColor: UIColor = .pickledBluewood
    static let subjectCellError: UIColor = .red
    static let subjectCellUnits: UIColor = UIColor.pickledBluewood.withAlphaComponent(0.6)
    static let subjectCellInactiveOverlay = UIColor.black.withAlphaComponent(0.75)
}

extension Theme.Font {
    
    // Dashboard
    static let dashboardNavBarTitleFont: UIFont = .systemFont(ofSize: 22)
    static let dashboardNavBarEditButtonFont: UIFont = .systemFont(ofSize: 16)
    static let dashboardFooterMoreButtonFont: UIFont = .systemFont(ofSize: 14)
    
    // Subject cell
    static let subjectCellName: UIFont = .systemFont(ofSize: 8)
    static let subjectCellError: UIFont = .systemFont(ofSize: 24)
    static let subjectCellUnits: UIFont = .systemFont(ofSize: 10)
    static let subjectCellMeasurement: UIFont = .systemFont(ofSize: 26)
}
