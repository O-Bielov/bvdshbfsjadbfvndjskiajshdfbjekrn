//
//  AuthFlow.swift

//
//    on 19.10.2021.
//

import UIKit
import AVFoundation


final class AuthFlow: Flow, ServiceProviding {
  
  var didAuthenticate: ((AuthFlow, SessionCredentials) -> Void)?
  
  private struct AuthInfo {
    var email = ""
    var passcode = ""
  }
    
  let services = ServiceLocator()
  
  private var authInfo = AuthInfo()
  
  private weak var passcodeModule: PasscodeModule?
  
  private var navigationViewController: UINavigationController {
    rootViewController as! UINavigationController
  }
  
  override func didMoveToParent() {
    super.didMoveToParent()
    
  
    let basePath = Constants.serverUrlPath
    
      let requestExecutor = HTTPRequestExecutor(
      configuration: .init(authorizationToken: "",
                           baseUrlPath: basePath))
    
    let mockExecutor = with(MockRequestExecutor()) {
      $0.setupMocks()
    }
    
    let compositeExecutor = CompositeRequestExecutor(
      mockExecutor: mockExecutor,
      actualExecutor: requestExecutor)
    
    with(services) {
      $0.register(ReachabilityChecker())
      $0.register(ApplicationErrorClassifier() as ErrorClassifier)
      $0.register(compositeExecutor as RequestExecuting)
      $0.takeOff()
    }
    
    registerForError(domain: .response, code: 401)
    
    let signInModule = SignInModule()
    addChild(signInModule)
    
    signInModule.didSubmitEmail = { [weak self] _, email in
      self?.authInfo.email = email
      self?.showPasscodeInputForm()
    }
    
    let signInController = SignInViewController(module: signInModule)
    signInModule.bindLifeCycle(to: signInController)
    
    let navigationController = UINavigationController(rootViewController: signInController)
    navigationController.navigationBar.makeTransparent()
    
    self.rootViewController = navigationController
  }
  
  override func handle(error: ApplicationError) {
    if error.domain == .response && error.code == 401 {
      rootViewController.makeErrorToast(error.localizedDescription)
      passcodeModule?.reset()
    }
  }
  
  func showPasscodeInputForm() {
    let passcodeModule = PasscodeModule()
 
    self.passcodeModule = passcodeModule
    
    passcodeModule.didConfirmCodeInput = { [weak self] _, code in
      self?.authInfo.passcode = code
      self?.authenticate()
    }
    
    addChild(passcodeModule)
    
    let passcodeController = PasscodeViewController(module: passcodeModule)
    
    passcodeModule.bindLifeCycle(to: passcodeController)
    
    navigationViewController.push(passcodeController)
  }
  
  func authenticate() {
    rootViewController.showLoadingView()
    requestExecutor
      .execute(.signIn(email: authInfo.email, passcode: authInfo.passcode))?
      .completion
      .deliver(on: .main)
      .observe { [weak self] result in
        guard let self = self else { return }
        self.rootViewController.hideLoadingView()
        if let result = result.success {
          self.didAuthenticate?(
            self,
            .init(sessionToken: result.accessToken,
                  userEmail: self.authInfo.email,
                  deviceKey: result.deviceKey,
                  refreshToken: result.refreshToken))
        }
        if let error = result.error {
          self.raise(error)
        }
      }.owned(by: self)
  }
  
}
