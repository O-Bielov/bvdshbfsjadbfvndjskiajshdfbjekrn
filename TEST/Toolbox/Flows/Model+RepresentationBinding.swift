//
//  Model+RepresentationBinding.swift

//
//    on 16.05.2021.
//

import Foundation

extension Module {
  
  func bindLifeCycle(to representation: NSObject) {
    representation.deinitSignal.observe { [weak self] in
      self?.removeFromParent()
    }.owned(by: self)
  }
  
}
