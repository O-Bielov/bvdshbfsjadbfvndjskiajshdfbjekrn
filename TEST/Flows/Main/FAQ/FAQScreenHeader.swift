//
//  FAQScreenHeader.swift

//
//    on 29.10.2021.
//

import UIKit

final class FAQScreenHeader: UICollectionReusableView {
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    setup()
  }
  
  required init?(coder: NSCoder) {
    fatalError()
  }

}

private extension FAQScreenHeader {
  
  func setup() {
    with(UILabel()) {
      $0.numberOfLines = 0
      $0.attributedText = "faq.screen_title"
        .localized
        .withStyle(.navigationTitle)
    }.add(to: self)
      .constrainEdgesToSuperview()
  }
  
}
