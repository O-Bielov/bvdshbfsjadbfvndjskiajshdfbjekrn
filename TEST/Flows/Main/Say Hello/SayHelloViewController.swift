//
//  SayHelloViewController.swift

//
//    on 01.11.2021.
//

import UIKit
import HandyText

final class SayHelloViewController: InputFormViewController {

  private lazy var showKeyboardOnStart = Once { [weak self] in
    self?.module.focusOnInitialField()
  }
  private let module: SayHelloModule

  init(module: SayHelloModule) {
    self.module = module
    
    super.init(form: module.inputForm)
  }
  
  required init?(coder: NSCoder) {
    fatalError()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setup()
    setupBindings()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    DispatchQueue.main.async {
      self.showKeyboardOnStart.execute()
    }
  }
  
  override func registerCells() {
    registerCellType(FormHeadingCell.self, for: FormHeadingField.self)
    registerCellType(ShortTextInputFieldCell.self, for: ShortTextInputField.self)
    registerCellType(LongTextInputFieldCell.self, for: LongTextInputField.self)
    registerCellType(BigButtonCell.self, for: ActionField.self)
  }
  
  override func requiredBehaviors() -> [CollectionViewBehavior] {
    [KeyboardHandlingBehavior(), DynamicHeightUpdateBehavior()]
  }
  
}

private extension SayHelloViewController {
  
  func setup() {
    addPinkBackButton()

    view.backgroundColor = .darkBackground
    collectionView.backgroundColor = .clear
  }
  
  func setupBindings() {
    module.isLoading.observe { [weak self] in
      if $0 { self?.view.endEditing(true) }
      $0
      ? self?.navigationController?.showLoadingView()
      : self?.navigationController?.hideLoadingView()
    }.owned(by: self)
  }
  
}
