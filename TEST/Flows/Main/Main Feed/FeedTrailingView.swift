//
//  FeedTrailingView.swift

//
//    on 21.10.2021.
//

import UIKit
import HandyText

final class FeedTrailingView: UICollectionReusableView {
  
  var didSelectInviteFriend: ((FeedTrailingView) -> Void)?
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    setup()
  }
  
  required init?(coder: NSCoder) {
    fatalError()
  }
  
}

private extension FeedTrailingView {
  
  func setup() {
    let smileLabel = with(UILabel()) {
      $0.text = "😎"
      $0.font = .systemFont(ofSize: 42.0)
    }
    
    let headerLabel = with(UILabel()) {
      $0.numberOfLines = 0
      $0.attributedText = "feed_trailing.header"
        .localized
        .withStyle(
          .init(font: .zoomPro)
            .size(34.0)
            .medium()
            .alignment(.center)
            .lineSpacing(-10.0)
            .minLineHeight(40.0)
            .maxLineHeight(40.0)
            .foregroundColor(.white)
        )
    }
    
    let messageLabel = with(UILabel()) {
      $0.numberOfLines = 0
      $0.attributedText = "feed_trailing.message"
        .localized
        .withStyle(
          .init(font: .neurial)
            .size(15.0)
            .regular()
            .alignment(.center)
            .lineSpacing(3.0)
            .foregroundColor(.hex("9B9BA3"))
        )
    }
    
    [smileLabel,
     headerLabel,
     .spacer(h: 16.0),
     messageLabel]
      .makeVStack() {
        $0.alignment = .center
      }
      .add(to: self)
      .pinToSuperview(leading: 40.0, trailing: 40.0)
      .pinCenterY()
    
    with(InviteFriendButton()) {
      $0.addTouchAction { [weak self] in
        guard let self = self else { return }
        self.didSelectInviteFriend?(self)
      }
    }.add(to: self)
      .pinToSuperview(leading: 24.0, trailing: 24.0, bottom: 58.0)
  }
  
}
