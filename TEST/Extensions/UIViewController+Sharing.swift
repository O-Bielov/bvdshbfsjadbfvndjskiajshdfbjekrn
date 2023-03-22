//
//  UIViewController+Sharing.swift

//
//    on 27.10.2021.
//

import UIKit

extension UIViewController {
  
  func showShareAppDialog() {
    let shareMessage = String(format: "feed.share_message_format".localized, Constants.appUrlString)
    
    showShareDialog(with: shareMessage)
  }

  func showShareDialog(with message: String) {
    let sharingController = UIActivityViewController(
      activityItems: [message],
      applicationActivities: nil)
    
    present(sharingController)
  }
  
}
