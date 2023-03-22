//
//  UnderlinedTextField.swift

//
//    on 26.10.2021.
//

import UIKit
import HandyText

final class UnderlinedTextField: UIView {
  
  private let underline = UIView()
  private let textField = UITextField()
  
  private var field: ShortTextInputField?
  private var subscriptionForErrorMessages: Subscription?
  private var subscriptionForText: Subscription?
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    setup()
    setupBindings()
  }
  
  required init?(coder: NSCoder) {
    fatalError()
  }
  
  override func becomeFirstResponder() -> Bool {
    textField.becomeFirstResponder()
  }
  
  func assignField(_ inputField: ShortTextInputField) {
    subscriptionForErrorMessages?.dispose()
    subscriptionForErrorMessages = nil
    
    subscriptionForText?.dispose()
    subscriptionForText = nil
    
    self.field = inputField
    
    subscriptionForErrorMessages = inputField
      .validationErrorMessages
      .observe { [weak self] _ in
      self?.updateUnderlineColor()
    }
    
    subscriptionForText = inputField.text.observe { [weak self] in
      if self?.textField.text != $0 {
        self?.textField.text = $0
      }
    }
    
    with(textField) {
      $0.attributedPlaceholder = inputField.placeholder.withStyle(.fieldPlaceholder)
      $0.autocapitalizationType = inputField.autocapitalizationType
      $0.autocorrectionType = inputField.autocorrectionType
      $0.keyboardType = inputField.keyboardType
    }
  }
  
}

private extension UnderlinedTextField {
  
  func setup() {
    underline.constrainHeight(to: 1.0)
    
    with(textField) {
      $0.applyAttributes(from: TextStyle.regularText)
      $0.delegate = self
      $0.addTarget(self,
                   action: #selector(textFieldTextDidChange),
                   for: .editingChanged)
    }
    
    [textField, underline]
      .makeVStack(spacing: 20.0)
      .add(to: self)
      .constrainEdgesToSuperview()
    
    updateUnderlineColor()
  }
  
  func setupBindings() {
  }
  
  func updateUnderlineColor() {
    if !(field?.validationErrorMessages.value.isEmpty ?? true) {
      underline.backgroundColor = .error
    } else {
      underline.backgroundColor = textField .isEditing ? .white : .hex("434352")
    }
    
    underline.transform = textField.isEditing ? .init(scaleX: 1.0, y: 2.0) : .identity
  }
  
}

extension UnderlinedTextField: UITextFieldDelegate {
  
  func textFieldDidBeginEditing(_ textField: UITextField) {
    updateUnderlineColor()
  }
  
  func textFieldDidEndEditing(_ textField: UITextField) {
    field?.commitEditing()
    updateUnderlineColor()
  }
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.endEditing(true)
  }
  
  @objc
  func textFieldTextDidChange(_ textField: UITextField) {
    field?.text.value = textField.text ?? ""
    updateUnderlineColor()
  }
  
}
