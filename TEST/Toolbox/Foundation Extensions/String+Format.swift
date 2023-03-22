//
//  String+Format.swift

//
//    on 25.12.2020.
//

import Foundation

extension String {
  
  func format(_ args: CVarArg...) -> String {
    String(format: self, args)
  }
  
}

