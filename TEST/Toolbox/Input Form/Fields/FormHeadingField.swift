//
//  FormHeadingField.swift

//
//    on 02.11.2021.
//

import Foundation

final class FormHeadingField: InputField {
  
  let title: String
  let subtitle: String
  
  init(title: String, subtitle: String) {
    self.title = title
    self.subtitle = subtitle
  }
  
}
