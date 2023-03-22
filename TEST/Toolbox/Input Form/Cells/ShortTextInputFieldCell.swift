//
//  ShortTextInputFieldCell.swift

//
//    on 15.02.2021.
//

import UIKit
import HandyText

final class ShortTextInputFieldCell: UICollectionViewCell, InputFieldDisplaying {
  
  private var field: ShortTextInputField?
  
  private var textField = UITextField()
  private let underline = UIView()
  
  private var focusToken: Subscription?
  private var textToken: Subscription?
  private var editingEnabledToken: Subscription?
  private var returnKeyToken: Subscription?
  private var subscriptionForErrorMessages: Subscription?
  
  override func prepareForReuse() {
    super.prepareForReuse()
    
    returnKeyToken?.dispose()
    returnKeyToken = nil
    focusToken?.dispose()
    focusToken = nil
    field = nil
    textToken?.dispose()
    textToken = nil
    editingEnabledToken?.dispose()
    editingEnabledToken = nil
    subscriptionForErrorMessages?.dispose()
    subscriptionForErrorMessages = nil

  }

  override init(frame: CGRect) {
    super.init(frame: frame)
    
    setup()
  }
  
  required init?(coder: NSCoder) {
    fatalError()
  }
  
  func display(_ field: InputField) {
    guard let field = field as? ShortTextInputField else { return }
    
    self.field = field
    
    focusToken = field.didReceiveFocus.observe { [weak self] in
      guard let textField = self?.textField else { return }
      _ = textField.becomeFirstResponder()
    }.owned(by: self)
        
    subscriptionForErrorMessages = field
      .validationErrorMessages
      .observe { [weak self] _ in
      self?.updateUnderlineColor()
    }

    returnKeyToken = field.returnKeyType.observe { [weak self, weak field] in
      guard let self = self, let field = field else { return }
      switch $0 {
      case .next: self.textField.returnKeyType = .next
      case .done: self.textField.returnKeyType = .done
      case .default: self.textField.returnKeyType = .default
      }
      let actionStyle: InputAccessoryView.ActionStyle = $0 == .next ? .next : .done
      if self.isAccessoryViewRequired(for: field.keyboardType) {
        self.textField.inputAccessoryView = InputAccessoryView(actionStyle: actionStyle) { [weak self] in
          self?.field?.resignFocus()
        }
      }
    }.owned(by: self)
        
    textToken = field.text.observe { [weak self] in
      self?.textField.text = $0
      self?.updateUnderlineColor()
    }.owned(by: self)
    
    editingEnabledToken = field.isEditable.observe { [weak self] in
      self?.textField.isUserInteractionEnabled = $0
      self?.textField.alpha = $0 ? 1.0 : 0.5
    }.owned(by: self)
    
    with(textField) {
      $0.autocapitalizationType = field.autocapitalizationType
      $0.autocorrectionType = field.autocorrectionType
      $0.keyboardType = field.keyboardType
      $0.placeholder = field.placeholder
      $0.applyAttributes(from: TextStyle.regularText)
      $0.attributedPlaceholder = field.placeholder.withStyle(.fieldPlaceholder)
      
      if let prefix = field.autoPrefix {
        $0.leftView = with(UILabel()) {
          $0.text = prefix
          $0.textColor = .white
        }.wrappedWithMargins(trailing: 3.0)
      } else {
        $0.leftView = nil
      }
    }
  }
  
}

private extension ShortTextInputFieldCell {
  
  func setup() {
    backgroundColor = .clear
    underline.constrainHeight(to: 1.0)
    
    with(textField) {
      $0.leftView = UIView.spacer(w: 18.0)
      $0.leftViewMode = .always
      $0.constrainHeight(to: 52.0)
      $0.delegate = self
      $0.addTarget(self,
                   action: #selector(textFieldTextDidChange),
                   for: .editingChanged)
      
    }.add(to: contentView)
      .pinToSuperview(leading: .margin,
                      trailing: .margin,
                      top: .zero,
                      bottom: .zero)
    
    underline.add(to: contentView)
      .constrainHeight(to: 1.0)
      .pinToSuperview(leading: .margin,
                      trailing: .margin,
                      bottom: .zero)
    
    updateUnderlineColor()
  }
  
  @objc
  func textFieldTextDidChange(_ textField: UITextField) {
    field?.text.value = textField.text ?? ""
  }
  
  func isAccessoryViewRequired(for keyboardType: UIKeyboardType) -> Bool {
    switch keyboardType {
    case .numbersAndPunctuation, .numberPad, .phonePad, .decimalPad: return true
    default: return false
    }
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

extension ShortTextInputFieldCell: HeightCalculating {}

extension ShortTextInputFieldCell: UITextFieldDelegate {
  
  func textFieldDidBeginEditing(_ textField: UITextField) {
    updateUnderlineColor()
  }
  
  func textFieldDidEndEditing(_ textField: UITextField) {
    field?.commitEditing()
    updateUnderlineColor()
  }
  
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    field?.resignFocus()
    return true
  }

}
