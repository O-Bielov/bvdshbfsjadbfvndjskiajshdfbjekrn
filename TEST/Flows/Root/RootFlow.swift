//
//  RootFlow.swift

//
//    on 19.10.2021.
//

import Toast_Swift
import UIKit

final class RootFlow: Flow, CredentialStoreProviding {
  
  private (set) var credentialStore = CredentialStore()
  
  override init() {
    super.init()
    
    rootViewController = RootViewController()
    
    registerForErrors(predicateDescription: "All unhandled errors") { _ in true }
    
    restart()
  }
  
  override func handle(error: ApplicationError) {
    let message = "Unhandled error:\n\(error.localizedDescription)\nUnderlying error: \(error.underlyingDescription)"
    rootViewController.view.makeToast(message)
  }
    
}

private extension RootFlow {
  
  var rootController: RootViewController {
    rootViewController as! RootViewController
  }
  
  func startAuthenticationFlow() {
    with(AuthFlow()) {
      $0.didAuthenticate = { [weak self] _, result in
        self?.authenticateAndRestart(with: result)
      }
      addChild($0)
      rootController.switchTo($0.rootViewController)
    }
  }
  
  func startMainFlow() {
    with(MainFlow()) {
      addChild($0)
      $0.didRequestSignOut = { [weak self] _ in
        self?.finishSessionAndRestart()
      }
      rootController.switchTo($0.rootViewController)
    }
  }
  
  func finishSessionAndRestart() {
    credentialStore.clearCredentials()
    restart()
  }
  
  func authenticateAndRestart(with credentials: SessionCredentials) {
    credentialStore.receiveCredentials(credentials)
    restart()
  }
   
  func restart() {
//    children.first?.close()
//
//    credentialStore.credentials == nil
//    ? startAuthenticationFlow()
//    : startMainFlow()
    
    startMainFlow()
  }

}

//27563Q
