//
//  UIViewController+Toasts.swift

//
//    on 27.10.2021.
//

import UIKit
import Toast_Swift

extension UIViewController {
  
  func childToShowToast() -> UIViewController {
    presentedViewController?.childToShowToast() ?? self
  }
  
  func makeErrorToast(_ message: String, action: (() -> Void)? = nil) {
    var style = ToastStyle()
    style.messageColor = .error
    style.titleColor = .red

     view.makeToast(message, style: style) { tapped in
      if tapped {
        action?()
      }
    }
  }
  
}
