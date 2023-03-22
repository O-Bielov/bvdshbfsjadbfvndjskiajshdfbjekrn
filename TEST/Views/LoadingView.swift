//
//  LoadingView.swift

//
//    on 21.10.2021.
//

import UIKit
import NVActivityIndicatorView

final class LoadingView: UIView {
  
  private var activityIndicator: NVActivityIndicatorView!
  private var backgroundView = UIImageView()
  
  override init(frame: CGRect) {
    super.init(frame: frame)

    setup()
  }
  
  required init?(coder: NSCoder) {
    fatalError()
  }
  
}

private extension LoadingView {
  
  func setup() {
    alpha = .zero
    
    backgroundColor = .black.withAlphaComponent(0.5)
    
    with(backgroundView) {
      $0.image = .init(named: "background.letters")
      $0.contentMode = .scaleAspectFill
    }.add(to: self)
      .constrainEdgesToSuperview()
    
    with(NVActivityIndicatorView(
      frame: .zero,
      type: .ballClipRotatePulse,
      color: .white,
      padding: .zero)) {
        self.activityIndicator = $0
        $0.startAnimating()
    }.add(to: self)
    .constrainWidth(to: 50.0)
    .constrainHeight(to: 50.0)
    .pinCenter()
  }
  
  func animateShow() {
    activityIndicator.transform = .init(scaleX: .zero, y: .zero)
    activityIndicator.alpha = .zero
    backgroundView.alpha = .zero
    
    alpha = 1.0
    
    activityIndicator.animate(t: 0.3) {
      $0.transform = .identity
      $0.alpha = 1.0
    }.start()
    
    backgroundView.animate(t: 0.1) {
      $0.alpha = 1.0
    }.start()
  }
  
  func animateHide() {
    guard alpha > .zero else { return }
    activityIndicator.animate(t: 0.2) {
      $0.transform = .init(scaleX: 0.1, y: 0.1)
      $0.alpha = .zero
    }.start()
    
    backgroundView.animate(t: 0.2, delay: 0.2) {
      $0.alpha = .zero
    }.then { _ in
      self.alpha = .zero
    }.start()
  }
  
}

extension UIViewController {
  
  func showLoadingView() {
    loadingView.animateShow()
  }
  
  func hideLoadingView() {
    loadingView.animateHide()
  }
  
  private static var loadingViewKey: UInt8 = 0
  
  fileprivate var loadingView: LoadingView {
    if let loadingView = objc_getAssociatedObject(self, &UIViewController.loadingViewKey) as? LoadingView {
      return loadingView
    } else {
      let loadingView = LoadingView()
        .add(to: view)
        .constrainEdgesToSuperview()
      objc_setAssociatedObject(self, &UIViewController.loadingViewKey,
                               loadingView,
                               .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
      return loadingView
    }
  }
  
}
