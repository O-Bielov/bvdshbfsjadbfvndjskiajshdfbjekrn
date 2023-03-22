//
//  ZeroInsetTextView.swift

//
//    on 31.12.2020.
//

import UIKit

class ZeroInsetTextView: UITextView {
   
  override func layoutSubviews() {
       super.layoutSubviews()
    
    textContainerInset = UIEdgeInsets.zero
    textContainer.lineFragmentPadding = 0
   }
  
}
