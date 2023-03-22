//
//  RateCell.swift

//
//    on 02.11.2021.
//

import Foundation
import UIKit

final class RateCell: UICollectionViewCell,
                        InputFieldDisplaying,
                        HeightCalculating {
    
  private let titleLabel = UILabel()
  private let ratingPicker = RatingPicker()
  private var field: RateField?
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    setup()
  }
  
  required init?(coder: NSCoder) {
    fatalError()
  }
  
  func display(_ field: InputField) {
    guard let field = field as? RateField else { return }
    
    self.field = field
    
    titleLabel.attributedText = field.title
      .withStyle(.regularText
                  .opacity(0.5)
                  .alignment(.center))
  }
  
  func height(atWidth width: CGFloat) -> CGFloat {
    UIDevice.isShort ? 150.0 : 195.0
  }
  
}

private extension RateCell {
  
  func setup() {
    titleLabel.numberOfLines = 0
    
    ratingPicker.addTarget(self, action: #selector(updateRating), for: .valueChanged)
    
    [titleLabel, ratingPicker]
      .makeVStack()
      .add(to: contentView)
      .pinToSuperview(leading: .margin, trailing: .margin)
      .pinCenterY()
    
    let makeSeparator: () -> UIView = {
      with(UIView()) {
        $0.constrainHeight(to: 1.0)
        $0.backgroundColor = .hex("434352")
      }
    }
    
    makeSeparator().add(to: contentView)
      .pinToSuperview(leading: .margin, trailing: .margin, top: .zero)
    makeSeparator().add(to: contentView)
      .pinToSuperview(leading: .margin, trailing: .margin, bottom: .zero)
    
  }
  
  @objc
  func updateRating(_ sender: RatingPicker) {
    field?.applyRating(sender.rating)
  }
  
}
