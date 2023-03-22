//
//  ApplicationTextStyles.swift

//
//    on 25.10.2021.
//

import HandyText

extension TextStyle {
  
  static let navigationTitle = TextStyle(font: .zoomPro)
    .medium()
    .size(34.0)
    .alignment(.left)
    .foregroundColor(.white)
    .tagScheme(.init {
      $0.tag("w") { _ in
          .init(font: .zoomProWide)
          .medium()
          .size(34.0)
          .foregroundColor(.white)
          .alignment(.left)
      }
    })
  
  static let regularText = TextStyle(font: .neurial)
    .regular()
    .size(15.0)
    .foregroundColor(.white)
    .lineSpacing(5.0)
  
  static let fieldPlaceholder = regularText
    .foregroundColor(.white)
    .opacity(0.45)
  
  static let pinkButton =  TextStyle(font: .zoomPro)
    .regular()
    .size(18.0)
    .alignment(.left)
    .foregroundColor(.palePink)
    .tagScheme(.init {
      $0.tag("b") { $0.bold() }
    })
  
  static let faqTitle = TextStyle(font: .neurial)
    .size(16.0)
    .medium()
    .foregroundColor(.white)
    .lineSpacing(3.0)
  
  static let faqAnswer = TextStyle(font: .neurial)
    .size(14.0)
    .regular()
    .foregroundColor(.white)
    .lineSpacing(3.0)
  
  static let legalInfo = TextStyle(font: .neurial)
    .size(14.0)
    .regular()
    .foregroundColor(.white)
    .lineSpacing(3.0)
    .opacity(0.4)
  
}
