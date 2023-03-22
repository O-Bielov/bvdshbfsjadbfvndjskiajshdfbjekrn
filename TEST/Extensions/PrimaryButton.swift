//
//  PrimaryButton.swift

//
//    on 01.11.2021.
//

import UIKit
import HandyText

final class PrimaryButton: UIButton {
  
  private let waveEffect = WaveTouchEffect()
  
  var isActionEnabled = true {
    didSet {
      backgroundColor = isActionEnabled ? .hex("FFF501") : .hex("434352")
      waveEffect.color = isActionEnabled ? .white : .white.withAlphaComponent(0.15)
    }
  }
  
  var title: String? {
    didSet {
      let style = TextStyle(font: .zoomPro)
        .medium()
        .foregroundColor(.black)
        .size(18.0)

      setAttributedTitle(title?.withStyle(style), for: .normal)
    }
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    setup()
  }
  
  required init?(coder: NSCoder) {
    fatalError()
  }
  
}

private extension PrimaryButton {
  
  func setup() {
    constrainHeight(to: 56.0)
    backgroundColor = .hex("FFF501")
    
    self.touchDecorator.addEffect(waveEffect)
  }
}
