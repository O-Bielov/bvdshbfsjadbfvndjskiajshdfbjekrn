//
//  ContinueButton.swift

//
//    on 26.10.2021.
//

import UIKit

final class ContinueButton: UIControl {
  
  private let button = UIButton()
  private let imageView = UIImageView()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    setup()
  }
  
  required init?(coder: NSCoder) {
    fatalError()
  }
  
  var isActionEnabled: Bool = true {
    didSet {
      UIView.animate(withDuration: imageView.image == nil ? .zero : 0.1) {
        self.imageView.image = self.isActionEnabled
        ? .init(named: "button.continue.enabled")
        : .init(named: "button.continue.disabled")
      }
    }
  }
  
}

private extension ContinueButton {
  
  func setup() {
    constrainWidth(to: 64.0)
      .aspectRatio(1.0)
    
    with(imageView) {
      $0.contentMode = .scaleAspectFit
    }.add(to: self)
      .constrainEdgesToSuperview()
    
    with(button) {
      $0 |> UIStyle.splashEffect
      $0.layer.cornerRadius = 32.0
      $0.layer.masksToBounds = true
      $0.addTouchAction { [weak self] in self?.sendActions(for: .touchUpInside) }
    }.add(to: self)
      .constrainEdgesToSuperview()
    
    isActionEnabled = true
  }
  
}
