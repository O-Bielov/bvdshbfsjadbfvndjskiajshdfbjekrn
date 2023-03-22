//
//  HeadingCell.swift

//
//    on 02.11.2021.
//

import UIKit

final class HeadingCell: UICollectionViewCell, InputFieldDisplaying, HeightCalculating {
  
  private let titleLabel = UILabel()
  private var titleToken: Subscription?
  
  override func prepareForReuse() {
    titleToken?.dispose()
    titleToken = nil
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    setup()
  }
  
  required init?(coder: NSCoder) {
    fatalError()
  }
  
  func display(_ field: InputField) {
    guard let field = field as? HeadingField else { return }
    
    titleToken = field.title.observe { [weak self] in
      self?.titleLabel.attributedText = $0.withStyle(.regularText.medium())
    }
  }
  
  func height(atWidth width: CGFloat) -> CGFloat {
    25.0
  }
  
}

private extension HeadingCell {
  
  func setup() {
    with(titleLabel) {
      $0.numberOfLines = 0
    }.add(to: contentView)
      .pinToSuperview(leading: .margin,
                      trailing: .margin,
                      top: .zero)
    
  }
  
}
