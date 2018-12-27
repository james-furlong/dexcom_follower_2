//
//  UITableView+Utilities.swift
//  Dexcom Follower
//
//  Created by James Furlong on 8/12/18.
//  Copyright © 2018 James Furlong. All rights reserved.
//

import UIKit

extension UITableView {
    func register<View>(view: View.Type) where View: UITableViewCell {
        register(view.self, forCellReuseIdentifier: view.defaultReuseIdentifier)
    }
    
    func registerHeaderFooterCiew<View>(view: View.Type) where View: UITableViewHeaderFooterView {
        register(view.self, forHeaderFooterViewReuseIdentifier: view.defaultReuseIdentifier)
    }
    
    func dequeue<T>(type: T.Type, for indexPath: IndexPath) -> T where T: UITableViewCell {
        let reuseIdentifier = T.defaultReuseIdentifier
        return dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! T
    }
    
    func dequeueHeaderFooterView<T>(type: T.Type, for indexPath: IndexPath) -> T where T: UITableViewHeaderFooterView {
        let reuseIdentifier = T.defaultReuseIdentifier
        return dequeueReusableHeaderFooterView(withIdentifier: reuseIdentifier) as! T
    }
}
