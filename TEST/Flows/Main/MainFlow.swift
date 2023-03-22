//
//  MainFlow.swift

//
//    on 19.10.2021.
//

import Foundation
import UIKit

final class MainFlow: Flow, ServiceProviding {
  
  var didRequestSignOut: ((MainFlow) -> Void)?
  
  let services = ServiceLocator()
  
  private var feedController: MainFeedViewController!
  
  private var navigationViewController: UINavigationController {
    rootViewController as! UINavigationController
  }
  
  override func didMoveToParent() {
    super.didMoveToParent()
    
//    let credentials = credentialStoreProvider?.sessionCredentials ?? .ini
    
    let basePath = Constants.serverUrlPath
    let requestExecutor = HTTPRequestExecutor(
      configuration: .init(authorizationToken: "abc",
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
      $0.register(LocalNotificationScheduler())
      $0.takeOff()
    }
    
    let feedModule = MainFeedModule()
    addChild(feedModule)
    
    with(MainFeedViewController(module: feedModule)) {
      feedController = $0
      
      $0.didSelectShowMenu = { [weak self] _ in
        self?.showMenu()
      }
      
      $0.didRequestAuthorPage = { [weak self] _, video in
        self?.showAuthorPage(for: video)
      }
    }
    
    feedModule.bindLifeCycle(to: feedController)
    
    let navigationController = UINavigationController(rootViewController: feedController)
    navigationController.navigationBar.makeTransparent()
        
    rootViewController = navigationController
    
    AppDelegateProxy.shared.didReceiveRemoteNotificationToken.observe { [weak self] in
      self?.sendPushToken($0)
    }.owned(by: self)
    
    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { success, error in
      if success {
        DispatchQueue.main.async {
          UIApplication.shared.registerForRemoteNotifications() // TODO: refactor
        }
      }
    }
    
    
  }
  
}

private extension MainFlow {
  
  func showAuthorPage(for video: Video) {
    guard let url = URL(string: video.creator.tiktokUrl) else { return }
    if UIApplication.shared.canOpenURL(url) {
      UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
  }
  
  func showMenu() {
    let settingsViewController = with(SettingsViewController()) {
      $0.didSelectNotificationSettings = { [weak self] _ in
        self?.showNotificationSettings()
      }
      $0.didSelectFAQ = { [weak self] _ in
        self?.showFAQ()
      }
      $0.didSelectTerms = { [weak self] _ in
        self?.showTerms()
      }
      $0.didSelectPrivacyPolicy = { [weak self] _ in
        self?.showPrivacyPolicy()
      }
      $0.didSelectSayHello = { [weak self] _ in
        self?.showSayHello()
      }
      $0.didSelectSendFeedback = { [weak self] _ in
        self?.sendFeedback()
      }
      $0.didRequestSignOut = { [weak self] _ in
        self?.signOut()
      }
    }
    
    navigationViewController.push(settingsViewController)
  }
  
  func showNotificationSettings() {
    let module = NotificationSettingsModule()
    
    let controller = NotificationSettingsViewController(module: module)
    
    module.bindLifeCycle(to: controller)
    
    navigationViewController.push(controller)
  }
  
  func showFAQ() {
    let module = FAQModule()
    addChild(module)
    
    let controller = FAQViewController(module: module)
    
    module.bindLifeCycle(to: controller)
    
    navigationViewController.push(controller)
  }
  
  func showTerms() {
    let controller = LegalInfoViewController(title: "terms.screen_title".localized,
                                             text: "")
    
    navigationViewController.push(controller)
  }
  
  func showPrivacyPolicy() {
    let controller = LegalInfoViewController(title: "privacy_policy.screen_title".localized,
                                             text: "")
    
    navigationViewController.push(controller)
  }
  
  func showSayHello() {
    let module = SayHelloModule()
    addChild(module)

    module.didSendMessage = { [weak self] _ in
      self?.navigationViewController.pop()
      self?.navigationViewController.view.makeToast("say_hello.message.completion".localized)
    }
    
    let controller = SayHelloViewController(module: module)

    module.bindLifeCycle(to: controller)

    navigationViewController.push(controller)
  }
  
  func sendFeedback() {
    let module = FeedbackModule()
    addChild(module)
    
    let controller = FeedbackViewController(module: module)
    
    module.bindLifeCycle(to: controller)
    
    module.didSendFeedback = { [weak self] _ in
      self?.navigationViewController.pop()
      self?.navigationViewController.view.makeToast("feedback.message.completion".localized)
    }
    
    navigationViewController.push(controller)
  }
  
  func signOut() {
    let alertController = UIAlertController(title: nil,
                                            message: "alert.sign_out.title".localized,
                                            preferredStyle: .alert)
    alertController.addAction(.init(title: "alert.sign_out.confirm_action".localized,
                                    style: .destructive) { [weak self] _ in
      self?.executeLogoutRequest()
//      self.map {$0.didRequestSignOut?($0) }
    })
    
    alertController.addAction(.cancel())
    
    rootViewController.present(alertController)
  }
  
  func sendPushToken(_ token: String) {
    guard let deviceKey = credentialStoreProvider?.sessionCredentials?.deviceKey else { return }
    
    requestExecutor.execute(.registerPushToken(token, deviceKey: deviceKey))
  }
  
  func executeLogoutRequest() {
    guard let credentials = credentialStoreProvider?.sessionCredentials else { return }
    
    // TODO: leaks, error
    
    rootViewController.showLoadingView()
    
    requestExecutor.execute(
      .logout(refreshToken: credentials.refreshToken,
              deviceKey: credentials.deviceKey))?
      .completion
      .deliver(on: .main)
      .observe { [weak self] result in
        guard let self = self else { return }
        self.rootViewController.hideLoadingView()
        if result.isSuccess {
          self.didRequestSignOut?(self)
        } else if let error = result.error {
          self.raise(error)
        }
      }.owned(by: self)
  }
  
}
