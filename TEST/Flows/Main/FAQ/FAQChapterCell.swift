//
//  FAQChapterCell.swift

//
//    on 29.10.2021.
//

import UIKit

final class FAQChapterCell: UICollectionViewCell {
  
  static let preferredInstanceHeigh = 56.0
  
  var chapter: FAQ.Chapter!
  
  private let titleLabel = UILabel()
  private let enclosureIndicator = EnclosureIndicator()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    setup()
  }
  
  required init?(coder: NSCoder) {
    fatalError()
  }
  
  func display(_ item: FAQItem) {
    guard let chapter = item as? FAQ.Chapter else { return }
    self.chapter = chapter
    titleLabel.attributedText = chapter.title.withStyle(.faqTitle)
  }
  
  override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
    super.apply(layoutAttributes)
    
    let attrs = layoutAttributes as! FAQLayoutAttributes

    enclosureIndicator.setMode(attrs.isCompact ? .closed : .opened, animated: true)
  }
  
}

private extension FAQChapterCell {
  
  func setup() {
    backgroundColor = .hex("E8EBF2").withAlphaComponent(0.1)
    
    titleLabel.numberOfLines = 0
    
    [titleLabel, enclosureIndicator].makeHStack(spacing: 10.0) {
      $0.alignment = .center
    }.add(to: self)
      .pinToSuperview(leading: .margin, trailing: .margin)
      .pinCenterY()
  }
  
}
