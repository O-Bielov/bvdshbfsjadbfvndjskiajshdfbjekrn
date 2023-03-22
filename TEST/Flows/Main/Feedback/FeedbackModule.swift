//
//  FeedbackModule.swift

//
//    on 02.11.2021.
//

import Foundation

final class FeedbackModule: Module {
  
  var didSendFeedback: ((FeedbackModule) -> Void)?
  
  let isLoading = Observable(false)
  
  let inputForm = FeedbackForm()

  override func didMoveToParent() {
    super.didMoveToParent()
    
    addChild(inputForm)
    
    inputForm.didSelectSend = { [weak self] _, feedback in
      self?.send(feedback)
    }
  }
  
  func focusOnInitialField() {
    inputForm.focusOnInitialField()
  }
  
}

private extension FeedbackModule {
  
  func send(_ feedback: Feedback) {
    isLoading.value = true
    
    requestExecutor.execute(.sendFeedback(feedback))?
      .completion
      .deliver(on: .main)
      .observe { [weak self] result in
        self?.isLoading.value = false
        switch result {
        case .success(_): self.map { $0.didSendFeedback?($0) }
        case .failure(let error): self?.raise(error)
        }
      }.owned(by: self)
  }
  
}

