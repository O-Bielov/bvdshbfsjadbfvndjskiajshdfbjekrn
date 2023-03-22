//
//  FormHeadingCell.swift

//
//    on 02.11.2021.
//

import UIKit

final class FormHeadingCell: UICollectionViewCell, InputFieldDisplaying, HeightCalculating {
  
  private let titleLabel = UILabel()
  private let subtitleLabel = UILabel()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    setup()
  }
  
  required init?(coder: NSCoder) {
    fatalError()
  }
  
  func display(_ field: InputField) {
    guard let inputField = field as? FormHeadingField else { return }
    
    titleLabel.attributedText = inputField.title.withStyle(.navigationTitle)
    subtitleLabel.attributedText = inputField.subtitle.withStyle(.regularText)

  }
  
  func height(atWidth width: CGFloat) -> CGFloat {
    100.0 // TODO: size calculation
  }
  
}

private extension FormHeadingCell {
  
  func setup() {
    backgroundColor = .clear

    [titleLabel, subtitleLabel].forEach {
      $0.numberOfLines = 0
    }
    
    [titleLabel, .spacer(h: 15.0), subtitleLabel, .spacer()]
      .makeVStack()
      .add(to: contentView)
      .pinToSuperview(leading: .margin, trailing: .margin, top: 0.0, bottom: .zero)
  }
  
}
