//
//  FeedbackForm.swift

//
//    on 02.11.2021.
//

import Foundation

final class FeedbackForm: InputForm {
  
  var didSelectSend: ((FeedbackForm, Feedback) -> Void)?
  
  let message = Pipe<String>()
  
  private let emailField = ShortTextInputField()
  private let messageField = LongTextInputField()
  private let rateField = RateField()
  private let optionField = OptionPickerField()
  private let reasonHeadingField = HeadingField()
  
  override func setup() {
    var allFields = [InputField]()
    
    with(FormHeadingField(title: "feedback.screen_title".localized,
                          subtitle: "feedback.screen_subtitle".localized)) {
      allFields.append($0)
    }
    
    with(rateField) {
      $0.title = "feedback.rate_question".localized
      $0.validator = .init { $0 == 0 ? .notValid([]) : .valid($0) }
      $0.applyRating(0)
      allFields.append($0)
    }
    
    allFields.append(reasonHeadingField)
    updateReasonHeading()
    
    with(optionField) {
      $0.title = "feedback.option_picker.description".localized
      allFields.append($0)
      $0.selectedOption.value = $0.options.value.first
    }
    
    let optionsMap = Constants.Feedback.experienceDescriptors
    
    rateField.rating.observe { [weak self] rating in
      guard let self = self else { return }
      
      let newOptions = (optionsMap[rating] ?? []).map(ChoiceOption.init)
      let oldOptions = self.optionField.options.value
      
      if newOptions != oldOptions {
        self.optionField.options.value = (optionsMap[rating] ?? []).map(ChoiceOption.init)
        self.optionField.selectedOption.value = nil
      }
      self.updateReasonHeading()
      self.updateHiddenFields()
    }.owned(by: self)
    
    with(HeadingField()) {
      $0.title.value = "feedback.heading.message".localized
      allFields.append($0)
    }
    
    with(messageField) {
      $0.placeholder = "feedback.message.placeholder".localized
      allFields.append($0)
    }
    
    let confirmField = with(ActionField()) {
      $0.action = { [weak self] in
        self?.raiseFeedback()
      }
      
      $0.disabledAction = { [weak self] in
        self?.fields.compactMap { $0 as? EditableField }.forEach {
          $0.commitEditing()
        }
        self?.message.send("feedback.message.rating_required".localized)
      }
      
      $0.actionTitle = "feedback.action.send".localized
      allFields.append($0)
    }
    
    isValid.observe { [weak confirmField] in
      confirmField?.isEnabled.value = $0
    }.owned(by: self)
    
    fields = allFields
    
    updateHiddenFields()
  }
  
  
  func focusOnInitialField() {
    if emailField.text.value.isEmpty {
      emailField.receiveFocus()
    } else {
      messageField.receiveFocus()
    }
  }

}

private extension FeedbackForm {
  
  func updateReasonHeading() {
    let heading: String
    switch rateField.rating.value {
    case 0: heading = ""
    case 1: heading = "feedback.low_rate.question".localized
    case 5: heading = "feedback.high_rate.question".localized
    default: heading = "feedback.mid_rate.question".localized
    }
    reasonHeadingField.title.value = heading
  }
  
  func updateHiddenFields() {
    hiddenFields = rateField.rating.value == 0
    ? [reasonHeadingField, optionField]
    : []
  }
  
  func raiseFeedback() {
    let feedback = Feedback(rating: rateField.rating.value,
                            reason: optionField.selectedOption.value?.title,
                            message: messageField.text.value,
                            email: credentialStoreProvider?.sessionCredentials?.userEmail ?? "")
    
    didSelectSend?(self, feedback)
  }
  
}

