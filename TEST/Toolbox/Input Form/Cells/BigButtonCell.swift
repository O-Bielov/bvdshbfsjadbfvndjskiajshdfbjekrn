//
//  BigButtonCell.swift

//
//    on 16.02.2021.
//

import UIKit

final class BigButtonCell: UICollectionViewCell {
  
  private let actionButton = PrimaryButton()
  private var field: ActionField?
    
  private var subscriptionForEnabledState: Subscription?
  
  override func prepareForReuse() {
    super.prepareForReuse()
    
    subscriptionForEnabledState?.dispose()
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    setup()
  }
  
  required init?(coder: NSCoder) {
    fatalError()
  }
  
}

extension BigButtonCell: InputFieldDisplaying {
  
  func display(_ field: InputField) {
    guard let field = field as? ActionField else { return }
    self.field = field
    
    actionButton.title = field.actionTitle

    subscriptionForEnabledState = field.isEnabled.observe { [weak self] isEnabled in
      UIView.animate(withDuration: 0.1) { [weak self] in
        self?.actionButton.isActionEnabled = isEnabled
      }
    }.owned(by: self)
  }
}

private extension BigButtonCell {
  
  func setup() {
    with(actionButton) {
      $0.addTouchAction { [weak self] in
        self?.field?.invokeActionAccordingToState()
      }
    }
    .add(to: contentView)
    .pinToSuperview(leading: .margin,
                    trailing: .margin,
                    top: .zero,
                    bottom: .zero)
  }
  
}

extension BigButtonCell: HeightCalculating {}
