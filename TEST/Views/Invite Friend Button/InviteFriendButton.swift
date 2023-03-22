//
//  InviteFriendButton.swift

//
//    on 27.10.2021.
//

import UIKit
import HandyText

final class InviteFriendButton: UIControl {
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    setup()
  }
  
  required init?(coder: NSCoder) {
    fatalError()
  }
  
}

private extension InviteFriendButton {
  
  func setup() {
    constrainHeight(to: 56.0)
    backgroundColor = .hex("FFF501")
    
    let scheme = TagScheme {
      $0.tag("b") { $0.bold() }
    }
    
    let actionLabel = with(UILabel()) {
      $0.attributedText = "feed_trailing.action.invite_friend"
        .localized
        .withStyle(
          .init(font: .zoomPro)
            .foregroundColor(.black)
            .size(18.0)
            .tagScheme(scheme)
        )
    }
    
    let icon = with(UIImageView()) {
      $0.image = .init(named: "icon.invite_friend")
    }
    
    with(UIButton()) {
      $0 |> UIStyle.waveEffect(.white)
      $0.addTouchAction { [weak self] in
        self?.sendActions(for: .touchUpInside)
      }
    }.add(to: self)
      .constrainEdgesToSuperview()
    
    [actionLabel, .spacer(), icon]
      .makeHStack() {
        $0.alignment = .center
        $0.isUserInteractionEnabled = false
      }.add(to: self)
      .pinToSuperview(leading: 20.0, trailing: 20.0)
      .pinCenterY()
  }
  
}
