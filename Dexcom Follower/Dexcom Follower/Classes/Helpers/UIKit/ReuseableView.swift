//
//  ReuseableView.swift
//  Dexcom Follower
//
//  Created by James Furlong on 8/12/18.
//  Copyright © 2018 James Furlong. All rights reserved.
//

import UIKit

public protocol ReusableView: class {
    static var defaultReuseIdentifier: String { get }
}

public extension ReusableView where Self: UIView {
    public static var defaultReuseIdentifier: String {
        return String(describing: self.self)
    }
}

extension UICollectionReusableView: ReusableView {}
extension UITableViewCell: ReusableView {}
extension UITableViewHeaderFooterView: ReusableView {}
