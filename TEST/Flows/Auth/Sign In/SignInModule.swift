//
//  SignInModule.swift

//
//    on 25.10.2021.
//

import Foundation

final class SignInModule: Module {
  
  var didSubmitEmail: ((SignInModule, String) -> Void)?
  
  let emailField = ShortTextInputField()
  
  override init() {
    super.init()
    
    with(emailField) {
      $0.placeholder = "sign_in.email_field.placeholder".localized
      $0.keyboardType = .emailAddress
      $0.autocorrectionType = .no
      $0.autocapitalizationType = .none
      $0.validator = .mandatoryField && .email
    }
  }
  
  override func didMoveToParent() {
    super.didMoveToParent()
    
  }
  
  func continueSignIn() {
    guard emailField.isValid.value else {
      emailField.receiveFocus()
      
      return
    }
    
    didSubmitEmail?(self, emailField.text.value)
  }
  
}
