//
//  UIControl+Blocks.swift

//
//    on 14.12.2020.
//

import UIKit

extension UIControl {
  
  func addTouchAction(_ action: @escaping () -> Void) {
    controlTarget.registerAction(action)
  }
  
}

private final class ControlTarget: NSObject {
  
  private var eventMap = [() -> Void]()
  
  func registerAction(_ action: @escaping () -> Void) {
    eventMap.append(action)
  }

  @objc
  func runActionForEvent(_ sender: Any?) {
    eventMap.forEach { $0() }
  }
  
}

private extension UIControl {
  
  private static var targetKey = ""
  
  var controlTarget: ControlTarget {
    var target: ControlTarget? = objc_getAssociatedObject(self, &UIControl.targetKey) as? ControlTarget
    if target == nil {
      target = ControlTarget()
      objc_setAssociatedObject(
        self as Any,
        &UIControl.targetKey,
        target,
        .OBJC_ASSOCIATION_RETAIN_NONATOMIC
      )
      addTarget(target,
                action: #selector(ControlTarget.runActionForEvent),
                for: .touchUpInside)
    }
    return target!
  }
  
}
