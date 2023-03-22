//
//  ErrorListView.swift

//
//    on 16.02.2021.
//

import UIKit
import HandyText

final class ValidationErrorView: UICollectionReusableView {
  
  var fieldId: UUID?
  
  private let contentStackView = UIStackView()
  private let messageLabel = UILabel()
  
  private var isIsolated = false
  
  init(isolated: Bool) {
    isIsolated = isolated
    
    super.init(frame: .zero)
    
    setup()
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    setup()
  }
  
  required init?(coder: NSCoder) {
    fatalError()
  }
  
  func display(_ errorMessages: [String]) {
    animatedTransition {
      self.messageLabel.attributedText = errorMessages
        .joined(separator: "\n")
        .withStyle(
          .regularText.sizeMultiplied(by: 0.75)
            .foregroundColor(.error)
        )
    }
  }
  
  override func systemLayoutSizeFitting(
    _ targetSize: CGSize,
    withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority,
    verticalFittingPriority: UILayoutPriority) -> CGSize {
        contentStackView.systemLayoutSizeFitting(
          targetSize,
          withHorizontalFittingPriority: horizontalFittingPriority,
          verticalFittingPriority: verticalFittingPriority)
  }

}

private extension ValidationErrorView {
  
  func setup() {
    with(contentStackView) {
      $0.axis = .vertical
    }.add(to: self)
      .pinToSuperview(leading: isIsolated ? .zero : .margin,
                      trailing: .margin,
                      top: .zero)
    
    contentStackView.addArrangedSubview(.spacer(h: 5.0))
    with(messageLabel) {
      $0.numberOfLines = 0
    }.add(to: contentStackView)
  }
  
}
