//
//  FeedbackViewController.swift

//
//    on 02.11.2021.
//

import Foundation


import UIKit
import HandyText

final class FeedbackViewController: InputFormViewController {

  private lazy var showKeyboardOnStart = Once { [weak self] in
    self?.module.focusOnInitialField()
  }
  private let module: FeedbackModule

  init(module: FeedbackModule) {
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
    registerCellType(LongTextInputFieldCell.self, for: LongTextInputField.self)
//    registerCellType(OptionPickerCell.self, for: OptionPickerField.self)
    registerCellType(FormHeadingCell.self, for: FormHeadingField.self)
    registerCellType(BigButtonCell.self, for: ActionField.self)
    registerCellType(HeadingCell.self, for: HeadingField.self)
    registerCellType(RateCell.self, for: RateField.self)
  }
  
  override func requiredBehaviors() -> [CollectionViewBehavior] {
    [KeyboardHandlingBehavior(), DynamicHeightUpdateBehavior()]
  }
  
}

private extension FeedbackViewController {
  
  func setup() {
    addPinkBackButton()

    setCustomTrailingSpacing(15.0, for: HeadingCell.self)
    
    view.backgroundColor = .darkBackground
    collectionView.backgroundColor = .clear
    
    (form as? FeedbackForm)?.message.observe { [weak self] in
      self?.view.makeToast($0)
    }.owned(by: self)
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
