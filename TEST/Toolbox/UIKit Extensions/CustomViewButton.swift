//
//  CustomViewButton.swift

//
//    on 21.12.2020.
//

import UIKit

final class CustomViewButton: UIControl {
  
  private let view: UIView
  
  init(_ view: UIView) {
    self.view = view
    
    super.init(frame: .zero)
    
    setup()
  }
  
  required init?(coder: NSCoder) {
    fatalError()
  }
  
}

private extension CustomViewButton {
  
  func setup() {
    view.add(to: self).constrainEdgesToSuperview()
    with(UITapGestureRecognizer()) {
      addGestureRecognizer($0)
      $0.addTarget(self, action: #selector(sendTouchEvent))
    }
  }
  
  @objc
  private func sendTouchEvent(_ sender: Any?) {
    sendActions(for: .touchUpInside)
  }
  
}

extension UIView {
  
  func makeButton(action: (() -> Void)? = nil) -> CustomViewButton {
    with(CustomViewButton(self)) {
      if let action = action {
        $0.addTouchAction(action)
      }
    }
  }
  
}
