//
//  PasscodeModule.swift

//
//    on 26.10.2021.
//

import Foundation

final class PasscodeModule: Module {

  var didConfirmCodeInput: ((PasscodeModule, String) -> Void)?
  
  private var code = ""
  
  let beginEditingIfNeeded = Pipe<Void>()
  let needsReset = Pipe<Void>()
  
  let isValid = Observable(false)
  
  func applyCode(_ code: String) {
    self.code = code
    isValid.value = code.count == Constants.passcodeLength
  }
  
  func confirmCodeInput() {
    guard isValid.value else {
      beginEditingIfNeeded.send(())
      return
    }
    
    didConfirmCodeInput?(self, code)
  }
  
  func reset() {
    code = ""
    needsReset.send(())
  }
  
}
