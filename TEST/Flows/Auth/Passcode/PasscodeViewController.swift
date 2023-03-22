//
//  PasscodeViewController.swift

//
//    on 26.10.2021.
//

import UIKit

final class PasscodeViewController: UIViewController {
  
  private let module: PasscodeModule
  private let codeInputView = PasscodeInputView(digits: Constants.passcodeLength)
  
  private lazy var showKeyboardOnStart = Once { [weak self] in
    _ = self?.codeInputView.becomeFirstResponder()
  }
  
  init(module: PasscodeModule) {
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
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    showKeyboardOnStart.execute()
  }
  
}

private extension PasscodeViewController {
  
  func setup() {
    view.backgroundColor = .darkBackground
    navigationItem.hidesBackButton = true
    
    let vStack = ScrollingStackView()
      .add(to: view)
      .pinToSuperview(leading: .margin,
                      trailing: .margin,
                      top: .zero,
                      bottom: .zero)

    vStack.addSpace(40.0)

    with(UILabel()) {
      $0.attributedText = "passcode.screen_title"
        .localized
        .withStyle(.navigationTitle)
    }.add(to: vStack)
    
    vStack.addSpace(20.0)
    
    with(UILabel()) {
      $0.numberOfLines = 0
      $0.attributedText = "passcode.check_email_message"
        .localized
        .withStyle(.regularText)
    }.add(to: vStack)
    
    vStack.addSpace(UIDevice.isShort ? 60.0 : 100.0)
    
    let codeInputViewInset = 50.0 - .margin
    
    with(codeInputView) {
      $0.codeInserted = { [weak self] _, code, completed in
        self?.module.applyCode(code)
      }
    }
      .wrappedWithMargins(
      leading: codeInputViewInset,
      trailing: codeInputViewInset)
      .add(to: vStack)
    
    attachFloatingContinueButton { [weak self] in
      guard let self = self else { return }
      self.module.confirmCodeInput()
      if self.module.isValid.value {
        self.view.endEditing(true)
      }
    }
  }
  
  func setupBindings() {
    module.isValid.observe { [weak self] in
      self?.floatingContinueButton.isActionEnabled = $0
    }.owned(by: self)
    
    module.beginEditingIfNeeded.observe { [weak self] in
      guard let self = self else { return }
      self.codeInputView.restoreEditing()
    }.owned(by: self)
    
    module.needsReset.observe { [weak self] in
      self?.codeInputView.reset()
    }.owned(by: self)
  }
  
}

