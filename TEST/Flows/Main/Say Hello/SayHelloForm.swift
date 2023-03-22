//
//  SayHelloForm.swift

//
//    on 02.11.2021.
//

import Foundation

final class SayHelloForm: InputForm {
  
  var didSelectSend: ((SayHelloForm) -> Void)?
  
  var email: String {
    emailField.text.value
  }
  
  var message: String {
    messageField.text.value
  }
  
  private let emailField = ShortTextInputField()
  private let messageField = LongTextInputField()
  override func setup() {
    let heading = FormHeadingField(title: "say_hello.screen_title".localized,
                                   subtitle: "say_hello.screen_subtitle".localized)
    
    with(emailField) {
      $0.placeholder = "sign_in.email_field.placeholder".localized
      $0.keyboardType = .emailAddress
      $0.autocorrectionType = .no
      $0.autocapitalizationType = .none
      $0.validator = .mandatoryField && .email
      $0.text.value = credentialStoreProvider?.sessionCredentials?.userEmail ?? ""
    }
    
    with(messageField) {
      $0.placeholder = "say_hello.message_placeholder".localized
      $0.keyboardType = .default
      $0.autocorrectionType = .default
      $0.autocapitalizationType = .sentences
      $0.validator = .mandatoryField
    }
    
    let confirmField = with(ActionField()) {
      $0.action = { [weak self] in
        self.map { $0.didSelectSend?($0) }
      }
      
      $0.disabledAction = { [weak self] in
        self?.fields.compactMap { $0 as? EditableField }.forEach {
          $0.commitEditing()
        }
      }
      
      $0.actionTitle = "say_hello.action.send".localized
    }
    
    isValid.observe { [weak confirmField] in
      confirmField?.isEnabled.value = $0
    }.owned(by: self)
    
    fields = [heading, emailField, messageField, confirmField]
  }
  
  func focusOnInitialField() {
    if emailField.text.value.isEmpty {
      emailField.receiveFocus()
    } else {
      messageField.receiveFocus()
    }
   
  }
  
}
