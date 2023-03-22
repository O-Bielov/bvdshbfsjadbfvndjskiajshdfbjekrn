//
//  SettingsViewController.swift

//
//    on 27.10.2021.
//

import UIKit

final class SettingsViewController: UIViewController {
  
  var didSelectNotificationSettings: ((SettingsViewController) -> Void)?
  var didSelectFAQ: ((SettingsViewController) -> Void)?
  var didSelectPrivacyPolicy: ((SettingsViewController) -> Void)?
  var didSelectTerms: ((SettingsViewController) -> Void)?
  var didSelectSayHello: ((SettingsViewController) -> Void)?
  var didSelectSendFeedback: ((SettingsViewController) -> Void)?
  var didRequestSignOut: ((SettingsViewController) -> Void)?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setup()
  }
  
}

private extension SettingsViewController {
  
  func setup() {
    view.backgroundColor = .darkBackground
    
    addPinkBackButton()
    
    let signOutView = [
      with(UILabel()) {
       $0.attributedText = "menu.action.sign_out"
         .localized
         .withStyle(.pinkButton)
     },
      with(UIView()) {
        $0.constrainHeight(to: 1.0)
        $0.backgroundColor = .palePink
      }
    ].makeVStack(spacing: 5.0)
      .makeButton { [weak self] in
        self.map { $0.didRequestSignOut?($0) }
      }
    
    navigationItem.rightBarButtonItem = .init(customView: signOutView)
    
    let vStack = ScrollingStackView()
      .add(to: view)
      .pinToSuperview(leading: .zero,
                      trailing: .zero,
                      top: .zero,
                      bottom: .zero)
    
    vStack.addSpace(UIDevice.isShort ? 10.0 : 40.0)
    
    with(UILabel()) {
      $0.attributedText = "menu.screen_title"
        .localized
        .withStyle(.navigationTitle.size(35.0))
    }.wrappedWithMargins(leading: .margin, trailing: .margin)
      .add(to: vStack)
    
    vStack.addSpace(UIDevice.isShort ? 10.0 : 20.0)
    
    [
      makeRow(title: "menu.item.faq".localized) { [weak self] in self.map { $0.didSelectFAQ?($0) }},
      makeRow(title: "menu.item.notifications".localized) { [weak self] in self.map { $0.didSelectNotificationSettings?($0) }},
      makeRow(title: "menu.item.terms".localized) { [weak self] in self.map { $0.didSelectTerms?($0) }},
      makeRow(title: "menu.item.privacy_policy".localized) { [weak self] in self.map { $0.didSelectPrivacyPolicy?($0) }},
      makeRow(title: "menu.item.contact_us".localized){ [weak self] in self.map { $0.didSelectSayHello?($0) }},
      makeRow(title: "menu.item.send_feedback".localized){ [weak self] in self.map { $0.didSelectSendFeedback?($0) }}
    ].interlaced {
      with(UIView()) {
        $0.backgroundColor = .white.withAlphaComponent(0.5)
        $0.constrainHeight(to: 1.0)
      }.wrappedWithMargins(leading: .margin, trailing: .margin)
    }.forEach {
      $0.add(to: vStack)
    }
    
    vStack.addSpace(UIDevice.isShort ? 5.0 : 14.0)
    
    makeSocialIconsRow()
      .wrappedWithMargins(leading: 13.0)
      .add(to: vStack)
    
    vStack.addSpace(UIDevice.isShort ? 10.0 : 24.0)
    
    with(UILabel()) {
      $0.attributedText = "menu.share_section.title"
        .localized
        .withStyle(
          .init(font: .neurial)
            .size(20.0)
            .foregroundColor(.white)
            .tagScheme(.init {
              $0.tag("b") { $0.bold() }
            })
          )
    }.wrappedWithMargins(leading: .margin, trailing: .margin)
      .add(to: vStack)
    
    vStack.addSpace(15.0)
    
    with(UILabel()) {
      $0.numberOfLines = 0
      $0.alpha = 0.8
      $0.attributedText = "menu.share_section.message"
        .localized
        .withStyle(
          .init(font: .neurial)
            .size(16.0)
            .lineSpacing(5.0)
            .foregroundColor(.white)
          )
    }.wrappedWithMargins(leading: .margin, trailing: .margin)
      .add(to: vStack)
    
    vStack.addSpace(UIDevice.isShort ? 20.0 : 30.0)
    
    with(InviteFriendButton()) {
      $0.addTouchAction { [weak self] in
        self?.showShareAppDialog()
      }
    }.wrappedWithMargins(leading: .margin,
                         trailing: .margin)
      .add(to: vStack)
  }
  
  func makeRow(title: String, action: @escaping () -> Void) -> UIView {
    let container = UIView().constrainHeight(to: UIDevice.isShort ? 44.0 : 60.0)
    
    with(UIButton()) {
      $0 |> UIStyle.waveEffect
      $0.addTouchAction(action)
    }.add(to: container)
      .constrainEdgesToSuperview()
    
    [.spacer(w: .margin),
     with(UILabel()) {
      $0.attributedText = title
        .withStyle(
          .init(font: .neurial)
            .medium()
            .size(16.0)
            .foregroundColor(.white)
        )
    },
     .spacer(),
     with(UIImageView()) {
      $0.image = .init(named: "chevron.right")
    },
     .spacer(w: .margin)
    ].makeHStack() {
      $0.isUserInteractionEnabled = false
      $0.alignment = .center
    }.add(to: container)
      .constrainEdgesToSuperview()
    
    return container
  }
  
  func makeSocialIconsRow() -> UIView {
    let hStack = SocialNetwork.allCases.map { item in
      with(UIButton()) {
        $0.alpha = 0.5
        $0.constrainWidth(to: 44.0)
        $0 |> UIStyle.splashEffect
        $0.layer.cornerRadius = 22.0
        $0.layer.masksToBounds = true
        $0.aspectRatio(1.0)
        $0.setImage(item.icon, for: .normal)
        $0.addTouchAction { [weak self] in
          self?.openURL(item.url)
        }
      }
    }.makeHStack(spacing: 10.0)
    
    UIView.spacer().add(to: hStack)
    
    return hStack
  }
  
  func openURL(_ url: URL) {
    if UIApplication.shared.canOpenURL(url) {
      UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
  }
  
}


private enum SocialNetwork: String, CaseIterable {
  case youtube, twitter, instagram, facebook, discord
  
  var icon: UIImage {
    .init(named: "social.\(rawValue)")!
  }
  
  var url: URL {
    let urlString: String = ""
    
    return URL(string: urlString)!
  }
  
}
