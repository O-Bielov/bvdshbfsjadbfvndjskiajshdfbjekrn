//
//  NotificationSettingsViewController.swift

//
//    on 27.10.2021.
//

import UIKit

final class NotificationSettingsViewController: UIViewController {
  
  private let module: NotificationSettingsModule
  
  init(module: NotificationSettingsModule) {
    self.module = module
    
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setup()
  }
  
}

private extension NotificationSettingsViewController {
  
  func setup() {
    view.backgroundColor = .darkBackground
    
    addPinkBackButton()
    
    let vStack = ScrollingStackView()
      .add(to: view)
      .pinToSuperview(leading: .margin,
                      trailing: .margin,
                      top: .zero,
                      bottom: .zero)
    
    vStack.addSpace(40.0)
    
    with(UILabel()) {
      $0.attributedText = "notifications.screen_title"
        .localized
        .withStyle(.navigationTitle.size(35.0))
    }.add(to: vStack)
    
    vStack.addSpace(20.0)
    
    with(UILabel()) {
      $0.numberOfLines = 0
      $0.attributedText = "notifications.screen_subtitle".localized
        .localized
        .withStyle(.regularText)
    }.add(to: vStack)
    
    vStack.addSpace(60.0)
    
    let dailyNotificationsRow = with(NotificationTypeRow()) {
      $0.title = "notifications.daily".localized
      $0.isOn = true
    }.add(to: vStack)
    
    
    // TODO: remove
    with(UILabel()) {
      $0.text = InstallInfo.id
      $0.textColor = .white.withAlphaComponent(0.1)
    }.add(to: vStack)
    
    dailyNotificationsRow.isOn = module.isLocalNotificationsEnabled
  }
  
}

private final class NotificationTypeRow: UIView {
  
  var isOn = false {
    didSet { switchControl.isOn = isOn }
  }
  
  var title: String? {
    didSet { titleLabel.attributedText = title?.withStyle(.regularText.medium()) }
  }
  
  private let titleLabel = UILabel()
  private let switchControl = UISwitch()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    setup()
  }
  
  required init?(coder: NSCoder) {
    fatalError()
  }
  
  private func setup() {
    constrainHeight(to: 56.0)
    
    [titleLabel, .spacer(), switchControl, .spacer(w: 3.0)]
      .makeHStack() {
        $0.alignment = .center
      }
      .add(to: self)
      .constrainEdgesToSuperview()
  }
  
}
