//
//  PasscodeInputView.swift

//
//    on 26.10.2021.
//

import UIKit
import HandyText

final class PasscodeInputView: UIView {
  
  var codeInserted: ((PasscodeInputView, String, Bool) -> Void)? // view, code, isComplete
  
  private let digitCount: Int
  private var stackView: UIStackView!
  private let smsObserverTextField = UITextField()
  private var textFields: [UITextField] {
    stackView.arrangedSubviews.compactMap { $0 as? UITextField }
  }
  
  init(digits: Int) {
    digitCount = digits
    super.init(frame: .zero)
    
    setup()
    subscribeForPasteboardChange()
  }
  
  required init?(coder: NSCoder) {
    fatalError()
  }
  
  override func becomeFirstResponder() -> Bool {
    textFields.first?.becomeFirstResponder() ?? false
  }
  
  func restartEditing() {
    textFields.forEach {
      $0.text = ""
      codeInserted?(self, "", false)
      textFields.first?.becomeFirstResponder()
    }
  }
  
  func restoreEditing() {
    guard (textFields.filter { $0.isFirstResponder }).isEmpty else { return }
    textFields
      .first { ($0.text ?? "").isEmpty }?
      .becomeFirstResponder()
  }
  
  override func endEditing(_ force: Bool) -> Bool {
    textFields.forEach { $0.endEditing(force) }
    return true
  }
  
  func reset() {
    textFields.forEach {
      $0.text = ""
    }
  }
  
}

private extension PasscodeInputView {
  
  func setup() {
    stackView = times(digitCount, makeTextField)
      .makeHStack(spacing: 20.0) {
        $0.arrangedSubviews.forEach {
          $0.aspectRatio(0.92)
        }
        $0.arrangedSubviews.makePairs().forEach { left, right in
          left.snp.makeConstraints {
            $0.width.equalTo(right.snp.width)
          }
        }
      }
      .add(to: self)
      .constrainEdgesToSuperview()
    
    refreshWithPasteboardContents()
  }
  
  func makeTextField() -> UITextField {
    
    with(DigitTextField()) {
      $0.textContentType = .oneTimeCode
      $0.autocapitalizationType = .allCharacters
      $0.autocorrectionType = .no
      $0.applyAttributes(
        from:
          TextStyle(font: .neurial)
          .regular()
          .size(35.0)
          .foregroundColor(.white)
      )
      $0.textAlignment = .center
      $0.delegate = self
      $0.addTarget(self,
                   action: #selector(textFieldTextDidChange),
                   for: .editingChanged)
      $0.backwardAction = { [weak self] in
        self?.deleteBackward($0)
      }
    }
  }
  
  func handleCodePaste(_ code: String) {
    guard code.count == textFields.count else { return }
    code
      .map(String.init)
      .enumerated().forEach { index, text in
        textFields[index].text = text
      }
    codeInserted?(self, code, code.count == digitCount)
  }
  
}

extension PasscodeInputView: UITextFieldDelegate {
  
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    if let text = textField.text,
             let textRange = Range(range, in: text) {
             let updatedText = text.replacingCharacters(in: textRange,
                                                         with: string)
      return updatedText.count <= 1
          }
    return true
  }
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    true
  }
  
  func textFieldDidBeginEditing(_ textField: UITextField) {
    textField.selectAll(nil)
  }
  
  func subscribeForPasteboardChange() {
    NotificationCenter.default.addObserver(
      self, selector: #selector(refreshWithPasteboardContents),
      name: UIApplication.didBecomeActiveNotification,
      object: nil)

    NotificationCenter.default.addObserver(
      self,
      selector: #selector(refreshWithPasteboardContents),
      name: UIPasteboard.changedNotification,
      object: nil)
    }
  
  @objc
  func refreshWithPasteboardContents() {
    if let code = UIPasteboard.general.string, code.count == digitCount {
      textFields.forEach {
        let accessoryView = with(PasteboardInputView(codeLength: digitCount)) {
          $0.didSelectCode = { [weak self] in
            self?.handleCodePaste($0)
          }
        }
        $0.inputAccessoryView = accessoryView
        $0.reloadInputViews()
      }
      } else {
        textFields.forEach {
          $0.inputAccessoryView = nil
          $0.reloadInputViews()
        }
    }
  }
  
}

private extension PasscodeInputView {
  
  @objc
  func textFieldTextDidChange(_ textField: UITextField) {
    if textField.text != "" {
      let index = textFields.firstIndex(of: textField)!
      let nextField = ([textField] + textFields.suffix(from: index).filter { ($0.text ?? "").isEmpty })
        .elementAfter(textField)
      if let nextField = nextField {
        nextField.becomeFirstResponder()
      } else {
        textField.endEditing(true)
      }
    }
    sendCodeIfNeeded()
  }
  
  func deleteBackward(_ sender: UITextField) {
    guard let previousField = textFields.elementBefore(sender) else { return }
    previousField.text = ""
    previousField.becomeFirstResponder()
  }
  
  func sendCodeIfNeeded() {
    let code = textFields
      .compactMap(get(\.text))
      .filter { !$0.isEmpty }
      .joined()
    if code.count == digitCount {
      endEditing(true)
    }
    codeInserted?(self, code, code.count == digitCount)
  }
  
}

private class DigitTextField: UITextField {
  
  var backwardAction: ((UITextField) -> Void)?
  
  private let underlineView = UIView()
  private let dashView = UIView()
  private var observationText: NSKeyValueObservation?
  
  override func becomeFirstResponder() -> Bool {
    updateAppearance()
    
    return super.becomeFirstResponder()
  }
  
  override func resignFirstResponder() -> Bool {
    updateAppearance()
    
    return super.resignFirstResponder()
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    addTarget(self, action: #selector(updateAppearance), for: .editingChanged)
    
    observationText = observe(\.text) { [weak self] _, _ in
      self?.updateAppearance()
    }
    
    underlineView.add(to: self)
      .constrainHeight(to: 1.0)
      .pinToSuperview(leading: .zero, trailing: .zero, bottom: .zero)

    with(dashView) {
      $0.backgroundColor = .hex("434352")
    }.add(to: self)
      .constrainHeight(to: 1.0)
      .pinCenterY()
      .pinToSuperview(leading: .zero, trailing: .zero)
    
    updateAppearance()
  }
  
  required init?(coder: NSCoder) {
    fatalError()
  }
  
  override func canPerformAction(_ action: Selector,
                                 withSender sender: Any?) -> Bool {
    false
  }
  
  @objc func updateAppearance() {
    let isEmtpyText = (self.text ?? "").isEmpty
    
    let shouldShowDashView = !isEditing && isEmtpyText
    self.dashView.alpha = shouldShowDashView ? 1.0 : .zero
    
    UIView.animate(withDuration: 0.1) {
      
      self.underlineView.backgroundColor = isEmtpyText
      ? .clear
      : .white
    }
  }
  
  override func deleteBackward() {
    if !(text ?? "").isEmpty {
      super.deleteBackward()
    } else {
      backwardAction?(self)
    }
  }
  
  override func shouldChangeText(in range: UITextRange, replacementText text: String) -> Bool {
    true
  }
  
}

private class PasteboardInputView: UIInputView {

  var didSelectCode: ((String) -> Void)?
  let isCodeAvailable = Observable(false)
  var owner: UITextField? { didSet {
    refreshWithPasteboardContents()
  }}

  private let codeLength: Int
  private let button = UIButton()
  private var code: String? {
    didSet {
      self.isHidden = code == nil
      button.setAttributedTitle((code ?? "")
                                  .insertSeparator(" ", atEvery: 1)
                                  .withStyle(
                                    TextStyle.regularText
                                      .size(30.0)
                                      .foregroundColor(.white)),
                                for: .normal)
    }
  }
  
  init(codeLength: Int) {
    self.codeLength = codeLength
    super.init(frame: CGRect(x: .zero,
                             y: .zero,
                             width: .zero,
                             height: 50.0),
               inputViewStyle: .keyboard)
    with(button) {
      $0.add(to: self)
      $0.layer.cornerRadius = 10.0
      $0.layer.cornerCurve = .continuous
      $0.backgroundColor = .black
      $0.contentEdgeInsets = .init(top: 5.0, left: 20.0, bottom: 5.0, right: 20.0)
      $0.addTouchAction { [weak self] in
        guard let code = self?.code else { return }
        self?.didSelectCode?(code)
      }
    }.pinCenterX()
    .pinToSuperview(top: 5.0, bottom: .zero)

    subscribeForPasteboardChange()
    refreshWithPasteboardContents()
  }

  required init?(coder: NSCoder) {
    fatalError()
  }

  func subscribeForPasteboardChange() {
    NotificationCenter.default.addObserver(
      self, selector: #selector(refreshWithPasteboardContents),
      name: UIApplication.didBecomeActiveNotification,
      object: nil)

    NotificationCenter.default.addObserver(
      self,
      selector: #selector(refreshWithPasteboardContents),
      name: UIPasteboard.changedNotification,
      object: nil)
    }

  @objc
  func refreshWithPasteboardContents() {
    if let code =  UIPasteboard.general.string {
      self.code = code
    } else {
      self.code = nil
    }
  }

}

extension String {

    func insertSeparator(_ separatorString: String, atEvery n: Int) -> String {
        guard 0 < n else { return self }
        return self.enumerated().map({String($0.element) + (($0.offset != self.count - 1 && $0.offset % n ==  n - 1) ? "\(separatorString)" : "")}).joined()
    }

    mutating func insertedSeparator(_ separatorString: String, atEvery n: Int) {
        self = insertSeparator(separatorString, atEvery: n)
    }
}
