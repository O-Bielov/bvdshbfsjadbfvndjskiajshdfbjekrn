//
//  RateField.swift

//
//    on 02.11.2021.
//

import Foundation

final class RateField: InputField {
  
  var validator: Validator<Int> = .alwaysValid() {
    didSet {
      updateValidity()
    }
  }

  var title = ""
  let rating = Observable(0)
  
  func applyRating(_ newRating: Int) {
    guard rating.value != newRating else { return }
    rating.value = newRating
    updateValidity()
  }
  
  func updateValidity() {
    isValid.value = validator.check(rating.value).isValid
  }
  
}
