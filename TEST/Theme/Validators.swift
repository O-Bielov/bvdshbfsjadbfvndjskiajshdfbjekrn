//
//  Validators.swift

//
//    on 26.10.2021.
//

import Foundation

extension Validator {

  static var email: Validator<String> {
    matchesRegexp("[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}",
                  errorFormat: "validation_error.bad_email".localized)
  }
  
  static var mandatoryField: Validator<String> {
    longerThan(0, "validation_error.mandatory_field".localized)
  }
  
}
