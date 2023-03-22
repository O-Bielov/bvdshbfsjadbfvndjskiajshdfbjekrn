//
//  SignInViewController.swift

//
//    on 25.10.2021.
//

import UIKit
import HandyText

final class SignInViewController: UIViewController {
  
  private let module: SignInModule
  private let errorView = ValidationErrorView(isolated: true)
  private let textField = UnderlinedTextField()
  private let messageTextView = UITextView()
  private let vStack = ScrollingStackView()
  
  private lazy var showKeyboardOnStart = Once { [weak self] in
    _ = self?.textField.becomeFirstResponder()
  }
  
  init(module: SignInModule) {
    self.module = module
    
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setup()
    setupBindings()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
      self.showKeyboardOnStart.execute()
    }
    
    vStack.arrangedSubviews.forEach {
      $0.transform = .init(translationX: .zero, y: $0.maxY / 3.0)
      
      $0.animate(t: 0.5, delay: 0.1 + ($0.maxY / self.view.height) * 0.7) {
        $0.transform = .identity
        $0.alpha = 1.0
      }.start()
    }
  }
  
}

private extension SignInViewController {
  
  func setup() {
    view.backgroundColor = .darkBackground

    let joinView = [
      with(UILabel()) {
       $0.attributedText = "sign_in.action.join_waitlist"
         .localized
         .withStyle(.pinkButton)
     },
      with(UIView()) {
        $0.constrainHeight(to: 1.0)
        $0.backgroundColor = .palePink
      }
    ].makeVStack(spacing: 5.0)
      .makeButton { [weak self] in
        self?.view.endEditing(true)
        self?.openWaitlistUrl()
      }
    
    navigationItem.rightBarButtonItem = .init(customView: joinView)
    
    vStack
      .add(to: view)
      .pinToSuperview(leading: .margin,
                      trailing: .margin,
                      top: .zero,
                      bottom: .zero)
    
    vStack.addSpace(40.0)
    
    with(UILabel()) {
      $0.attributedText = "sign_in.screen_title"
        .localized
        .withStyle(.navigationTitle)
    }.add(to: vStack)
    
    vStack.addSpace(20.0)
    
    with(UILabel()) {
      $0.numberOfLines = 0
      $0.attributedText = "sign_in.waitlist_call_to_action"
        .localized
        .withStyle(.regularText)
    }.add(to: vStack)
    
    vStack.addSpace(65.0)
    
    with(textField) {
      $0.assignField(module.emailField)
    }.add(to: vStack)
    
    vStack.addSpace(3.0)
    
    errorView.add(to: vStack)
    
    attachFloatingContinueButton { [weak self] in
      self?.module.continueSignIn()
      self?.view.endEditing(true)
    }
    
    vStack.arrangedSubviews.forEach {
      $0.alpha = .zero
    }
  }
  
  func setupBindings() {
    module.emailField.validationErrorMessages.observe { [weak self] in
      self?.errorView.display($0)
    }.owned(by: self)
    
    module.emailField.isValid.observe { [weak self] in
      self?.floatingContinueButton.isActionEnabled = $0
    }.owned(by: self)
  }
  
  func openWaitlistUrl() {
    return
  }
  
}
