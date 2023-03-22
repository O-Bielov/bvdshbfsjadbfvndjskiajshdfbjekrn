//
//  UIViewController+LeftAlignedTitle.swift

//
//    on 21.10.2021.
//

import UIKit

extension UIViewController {
  
  var leftAlignedTitle: String? {
    get { nil }
    set {
      let title = newValue ?? ""
      let titleView = with(UILabel()) {
        $0.attributedText = title
          .withStyle(.init(font: .zoomProWide)
                      .medium()
                      .foregroundColor(.white)
                      .size(25.0))
      }
      
      navigationItem.leftBarButtonItem = .init(customView: titleView.wrappedWithMargins(leading: 5.0))
    }
  }
  
}
