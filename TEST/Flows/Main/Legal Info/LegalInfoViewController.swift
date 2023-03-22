//
//  LegalInfoViewController.swift

//
//    on 29.10.2021.
//

import UIKit

final class LegalInfoViewController: UIViewController {
  
  private let screenTitle: String
  private let text: String
  
  init(title: String, text: String) {
    self.screenTitle = title
    self.text = text
    
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

private extension LegalInfoViewController {
  
  func setup() {
    view.backgroundColor = .darkBackground
    addPinkBackButton()
    
    let vStack = ScrollingStackView()
      .add(to: view)
      .pinToSuperview(leading: .margin, trailing: .margin, top: .zero, bottom: .zero)
    
    vStack.addSpace(40.0)
    
    with(UILabel()) {
      $0.numberOfLines = 0
      $0.attributedText = screenTitle
        .withStyle(.navigationTitle)
    }.add(to: vStack)
    
    vStack.addSpace(30.0)
    
    with(UILabel()) {
      $0.numberOfLines = 0
      $0.attributedText = text.withStyle(.legalInfo)
    }.add(to: vStack)
  }
  
}
