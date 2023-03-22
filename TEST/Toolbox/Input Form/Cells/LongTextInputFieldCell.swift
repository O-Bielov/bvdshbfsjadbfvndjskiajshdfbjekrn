//
//  LongTextInputFieldCell.swift

//
//    on 02.11.2021.
//

import UIKit
import HandyText

final class LongTextInputFieldCell: UICollectionViewCell,
                                    InputFieldDisplaying,
                                    HeightCalculating,
                                    DynamicHeightUpdating {
  
  var needsUpdateHeight: ((DynamicHeightUpdating) -> Void)?
  
  private let textView = ZeroInsetTextView()
  private let placeholderTextView = ZeroInsetTextView()
  
  private let underline = UIView()
  private var subscriptionForErrorMessages: Subscription?
  
  private var focusToken: Subscription?
  private var returnKeyToken: Subscription?
  private var textToken: Subscription?
  private var editingEnabledToken: Subscription?
  
  private var field: LongTextInputField?
  
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
    guard let inputField = field as? LongTextInputField else { return }
        
    self.field = inputField
    
    subscriptionForErrorMessages = inputField
      .validationErrorMessages
      .observe { [weak self] _ in
      self?.updateUnderlineColor()
    }
    
    textToken = inputField.text.observe { [weak self] in
      if self?.textView.text != $0 {
        self?.textView.text = $0
      }
    }
    
    returnKeyToken = field.returnKeyType.observe { [weak self, weak inputField] in
      guard let self = self, let field = inputField else { return }
      switch $0 {
      case .next: self.textView.returnKeyType = .next
      case .done: self.textView.returnKeyType = .done
      case .default: self.textView.returnKeyType = .default
      }
      let actionStyle: InputAccessoryView.ActionStyle = $0 == .next ? .next : .done
      if self.isAccessoryViewRequired(for: field.keyboardType) {
        self.textView.inputAccessoryView = InputAccessoryView(actionStyle: actionStyle) { [weak self] in
          self?.field?.resignFocus()
        }
      }
    }.owned(by: self)
    
    focusToken = field.didReceiveFocus.observe { [weak self] in
      guard let textView = self?.textView else { return }
      _ = textView.becomeFirstResponder()
    }.owned(by: self)
    
    placeholderTextView.text = inputField.placeholder
    
    with(textView) {
      $0.autocapitalizationType = inputField.autocapitalizationType
      $0.autocorrectionType = inputField.autocorrectionType
      $0.keyboardType = inputField.keyboardType
    }
  }
  
  func height(atWidth width: CGFloat) -> CGFloat {
    let textViewSize = textView.sizeThatFits(CGSize(width: width - .margin * 2.0,
                                                    height: CGFloat.greatestFiniteMagnitude))

    
    let placeholderSize = placeholderTextView.sizeThatFits(CGSize(width: width - .margin * 2.0,
                                                    height: CGFloat.greatestFiniteMagnitude))

    
    return max(textViewSize.height, placeholderSize.height)
  }
  
}

private extension LongTextInputFieldCell {
  
  func setup() {
    underline.constrainHeight(to: 1.0)
    
    with(placeholderTextView) {
      $0.backgroundColor = .clear
      $0.applyAttributes(from: TextStyle.fieldPlaceholder)
      $0.isUserInteractionEnabled = false
    }.add(to: contentView)
      .pinToSuperview(leading: .margin,
                      trailing: .margin,
                      top: .zero,
                      bottom: .zero)
    
    with(textView) {
      $0.backgroundColor = .clear
      $0.typingAttributes = TextStyle.regularText.textAttributes
      $0.delegate = self
    }.add(to: contentView)
      .pinToSuperview(leading: .margin,
                      trailing: .margin,
                      top: .zero,
                      bottom: .zero)
        
    underline.add(to: contentView)
      .pinToSuperview(leading: .margin,
                      trailing: .margin,
                      bottom: .zero)
    
    updateUnderlineColor()
  }
  
  func updateUnderlineColor() {
    if !(field?.validationErrorMessages.value.isEmpty ?? true) {
      underline.backgroundColor = .error
    } else {
      underline.backgroundColor = textView.isFirstResponder ? .white : .hex("434352")
    }
    
    underline.transform = textView.isFirstResponder ? .init(scaleX: 1.0, y: 2.0) : .identity
  }
  
  func isAccessoryViewRequired(for keyboardType: UIKeyboardType) -> Bool {
    switch keyboardType {
    case .numbersAndPunctuation, .numberPad, .phonePad, .decimalPad: return true
    default: return false
    }
  }
  
}

extension LongTextInputFieldCell: UITextViewDelegate {
  
  func textViewDidBeginEditing(_ textView: UITextView) {
    updateUnderlineColor()
    field?.receiveFocus()
  }
  
  func textViewDidEndEditing(_ textView: UITextView) {
    field?.commitEditing()
    updateUnderlineColor()
  }
  
  func textView(_ textView: UITextView,
                shouldChangeTextIn range: NSRange,
                replacementText text: String) -> Bool {
    if text == "\n" {
           textView.resignFirstResponder()
      textView.endEditing(true)
           return false
       }
       return true
  }
  
  func textViewDidChange(_ textView: UITextView) {
    placeholderTextView.isHidden = !textView.text.isEmpty
    field?.text.value = textView.text ?? ""
      updateUnderlineColor()

    let oldHeight = textView.height
    let newHeight = textView.sizeThatFits(CGSize(width: textView.frame.size.width,
                                                 height: .greatestFiniteMagnitude)).height
    if oldHeight != newHeight {
      needsUpdateHeight?(self)
    }
  }
  
}
