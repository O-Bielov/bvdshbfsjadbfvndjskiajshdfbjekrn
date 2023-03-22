//
//  UITableView+Dequeuing.swift

//
//    on 10.12.2020.
//

import UIKit

extension UITableView {
  
  func registerCellClass<T: UITableViewCell>(_ cellClass: T.Type) {
    register(cellClass, forCellReuseIdentifier: String(describing: cellClass.self))
  }
  
  func dequeueCell<T: UITableViewCell>(for indexPath: IndexPath) -> T {
    dequeueReusableCell(withIdentifier: String(describing: T.self), for: indexPath) as! T
  }

}
