//
//  SayHelloModule.swift

//
//    on 01.11.2021.
//

import Foundation

final class SayHelloModule: Module {

  var didSendMessage: ((SayHelloModule) -> Void)?
  
  let isLoading = Observable(false)
  
  let inputForm = SayHelloForm()

  override func didMoveToParent() {
    super.didMoveToParent()
    
    addChild(inputForm)
    
    inputForm.didSelectSend = { [weak self] in
      self?.send(message: $0.message, email: $0.email)
    }
  }
  
  func focusOnInitialField() {
    inputForm.focusOnInitialField()
  }
  
}

private extension SayHelloModule {
  
  func send(message: String, email: String) {
    isLoading.value = true
    
    requestExecutor.execute(.sendMessage(message, email: email))?
      .completion
      .deliver(on: .main)
      .observe { [weak self] result in
        self?.isLoading.value = false
        switch result {
        case .success(_): self.map { $0.didSendMessage?($0) }
        case .failure(let error): self?.raise(error)
        }
      }.owned(by: self)
  }
  
}
