//
//  ManagedProperty.swift

//
//    on 15.04.2021.
//

import Foundation

struct ManagedProperty<T> {
  
  var get: () -> T
  var set: (T) -> ()
  
}
