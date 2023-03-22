//
//  UnderlinedTextView.swift

//
//    on 01.11.2021.
//

import UIKit
import HandyText

final class UnderlinedTextView: UIView {
 
  private let textView = ZeroInsetTextView()
  private let placeholderTextView = ZeroInsetTextView()
  
  private let underline = UIView()
  private var field: ShortTextInputField?
  private var subscriptionForErrorMessages: Subscription?
  private var subscriptionForText: Subscription?
  private var subscriptionForTextInternal: NSKeyValueObservation?
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    setup()
  }
  
  required init?(coder: NSCoder) {
    fatalError()
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
      if self?.textView.text != $0 {
        self?.textView.text = $0
      }
    }
    
    placeholderTextView.text = field?.placeholder
    
    with(textView) {
      $0.autocapitalizationType = inputField.autocapitalizationType
      $0.autocorrectionType = inputField.autocorrectionType
      $0.keyboardType = inputField.keyboardType
    }
  }
  
}

private extension UnderlinedTextView {
  
  func setup() {
    underline.constrainHeight(to: 1.0)

    
    with(placeholderTextView) {
      $0.backgroundColor = .clear
      $0.applyAttributes(from: TextStyle.fieldPlaceholder)
      $0.isUserInteractionEnabled = false
    }.add(to: self)
      .constrainEdgesToSuperview()
    
    with(textView) {
      $0.backgroundColor = .clear
      $0.typingAttributes = TextStyle.regularText.textAttributes
      $0.delegate = self
      $0.textStorage.delegate = self
    }.add(to: self)
      .constrainEdgesToSuperview()
    
    
    underline.add(to: self)
      .pinToSuperview(leading: .zero,
                      trailing: .zero,
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
  
}

extension UnderlinedTextView: NSTextStorageDelegate {
  func textStorage(_ textStorage: NSTextStorage,
                   didProcessEditing editedMask: NSTextStorage.EditActions,
                   range editedRange: NSRange,
                   changeInLength delta: Int) {
    placeholderTextView.isHidden = !textView.text.isEmpty
    field?.text.value = textView.text ?? ""
      updateUnderlineColor()
  }
}

extension UnderlinedTextView: UITextViewDelegate {
  
  func textViewDidBeginEditing(_ textView: UITextView) {
    updateUnderlineColor()
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
  
}
