//
//  UIViewController+ContinueButton.swift

//
//    on 26.10.2021.
//

import UIKit

extension UIViewController {
  
  private static var floatingButtonKey: UInt8 = 0
  private static var keyboardListenerKey: UInt8 = 0
  
  var floatingContinueButton: ContinueButton {
    if let button = objc_getAssociatedObject(self, &UIViewController.floatingButtonKey) as? ContinueButton {
      return button
    } else {
      let button = ContinueButton()
      setupContinueButton(button)
      objc_setAssociatedObject(self, &UIViewController.floatingButtonKey,
                               button,
                               .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
      return button
    }
  }
  
  func attachFloatingContinueButton(_ action: @escaping () -> Void) {
    floatingContinueButton.addTouchAction(action)
  }
  
}

private extension UIViewController {
  
  private var keyboardListener: KeyboardListener {
    if let listener = objc_getAssociatedObject(self, &UIViewController.keyboardListenerKey) as? KeyboardListener {
      return listener
    } else {
      let listener = KeyboardListener()
      objc_setAssociatedObject(self, &UIViewController.keyboardListenerKey,
                               listener,
                               .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
      return listener
    }
  }
  
  func animateKeyboardShow(options: KeyboardAnimationOptions) {
    let keyboardFrame = options.frameEnd
    let keyboardHeight = keyboardFrame.height - UIDevice.safeAreaInsets.bottom
    
    let duration = options.duration
    let curve = UInt(options.curve.rawValue)
    let animationOption = UIView.AnimationOptions(rawValue: curve)
    
    let offset: CGFloat = UIDevice.safeAreaInsets.bottom == .zero ? .zero : .margin
    
    UIView.animate(
      withDuration: duration,
      delay: .zero,
      options: [animationOption],
      animations: { [weak self] in
        self?.floatingContinueButton.transform = .init(translationX: .zero, y: -(keyboardHeight + offset))
    })
  }
  
  func animateKeyboardHide(options: KeyboardAnimationOptions) {
    let duration = options.duration
    let curve = UInt(options.curve.rawValue)
    let animationOption = UIView.AnimationOptions(rawValue: curve)

    UIView.animate(
      withDuration: duration,
      delay: .zero,
      options: [animationOption],
      animations: {
        self.floatingContinueButton.transform = .identity
    })
  }
  
}

private extension UIViewController {
  
  func setupContinueButton(_ button: ContinueButton) {
    button
      .add(to: view)
        .pinToSuperview(
          trailing: .margin,
          bottom: max(.margin, UIDevice.safeAreaInsets.bottom)
        )
    
    keyboardListener.keyboardWillShow.observe { [weak self] options in
      self?.animateKeyboardShow(options: options)
    }.owned(by: self)
    
    keyboardListener.keyboardWillHide.observe { [weak self] options in
      self?.animateKeyboardHide(options: options)
    }.owned(by: self)
  }
  
}
