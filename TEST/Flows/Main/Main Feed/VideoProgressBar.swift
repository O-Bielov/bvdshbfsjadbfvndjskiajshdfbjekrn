//
//  VideoProgressBar.swift

//
//    on 20.10.2021.
//

import UIKit

final class VideoProgressBar: UIView {
  
  private let progressView = UIView()
  
  var progress = 0.0 {
    didSet {
      if progress < .zero { progress = .zero }
      if progress > 1.0 { progress = 1.0 }
      
      updateProgress()
    }
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    setup()
  }
  
  required init?(coder: NSCoder) {
    fatalError()
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    updateProgress()
  }
  
}

private extension VideoProgressBar {
  
  func setup() {
    constrainHeight(to: 5.0)
    layer.cornerRadius = 2.5
    backgroundColor = .white.withAlphaComponent(0.2)
    
    with(progressView) {
      $0.backgroundColor = .hex("FD8CC4")
      $0.layer.cornerRadius = 0.5
    }.add(to: self)
  }
  
  func updateProgress() {
    let inset = 2.0
    let fullWidth = width - inset * 2.0
    
    let partitionWidth = fullWidth * progress
    progressView.frame.width = partitionWidth
    progressView.frame.height = 1.0
    progressView.frame.origin.x = inset
    progressView.frame.origin.y = (height - progressView.height) / 2.0
  }
  
}
 
