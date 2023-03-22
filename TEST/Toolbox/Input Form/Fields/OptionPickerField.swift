//
//  OptionPickerField.swift

//
//    on 22.04.2021.
//

import Foundation

struct ChoiceOption: Equatable {

  let uid: String
  let title: String
  
  static func ==(lhs: ChoiceOption, rhs: ChoiceOption) -> Bool {
    lhs.uid == rhs.uid
  }
 
  init(string: String) {
    uid = string
    title = string
  }
  
  init(uid: String, title: String) {
    self.uid = uid
    self.title = title
  }
  
}

final class OptionPickerField: InputField {
  
  var title = ""
  let selectedOption = Observable<ChoiceOption?>(nil)
  let options = Observable<[ChoiceOption]>([])
      
  func selectOption(_ option: ChoiceOption) {
    selectedOption.value = option
  }
  
}
