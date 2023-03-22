//
//  Array+Duplicates.swift

//
//    on 24.02.2021.
//

import Foundation

extension Array where Element: Hashable {
  func uniqued() -> [Element] {
    var seen = Set<Element>()
    return filter { seen.insert($0).inserted }
  }
}
