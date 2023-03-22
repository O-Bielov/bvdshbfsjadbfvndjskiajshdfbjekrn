//
//  RatingPicker.swift
 
//
//    on 02.11.2021.
//

import UIKit

final class RatingPicker: UIControl {
  
  var rating = 0 {
    didSet {
      updateHighligtedStars()
      sendActions(for: .valueChanged)
    }
  }
  
  private let hStack = UIStackView()
  
  private var stars: [UIImageView] {
    hStack.arrangedSubviews.compactMap { $0 as? UIImageView }
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    setup()
    addStars()
    updateHighligtedStars()
  }
  
  required init?(coder: NSCoder) {
    fatalError()
  }
  
}

private extension RatingPicker {
  
  func setup() {
    constrainHeight(to: 70.0)
    
    hStack
      .add(to: self)
      .pinToSuperview(top: .zero, bottom: .zero)
      .pinCenterX()
    
    with(UIPanGestureRecognizer()) {
      $0.addTarget(self, action: #selector(handlePan))
      hStack.addGestureRecognizer($0)
    }
    
    with(UITapGestureRecognizer()) {
      $0.addTarget(self, action: #selector(handlePan))
      hStack.addGestureRecognizer($0)
    }
  }
  
  func addStars() {
    repeatTimes(5) {
      makeStar().add(to: hStack)
    }
  }
  
  func makeStar() -> UIImageView {
    with(UIImageView()) {
      $0.contentMode = .center
      $0.highlightedImage = .init(named: "icon.star_filled")
      $0.image = .init(named: "icon.star_empty")
        $0.constrainWidth(to: 60.0)
    }
  }
  
  func updateHighligtedStars() {
    hStack.animatedTransition(duration: 0.1) {
      self.stars.enumerated().forEach { index, star in
        let isActive = index < self.rating
        star.isHighlighted = isActive
      }
    }
  }
  
  @objc
  private func handlePan(_ sender: UIPanGestureRecognizer) {
    let location = sender.location(in: hStack).x
    let rating = min(max(1, ceil(5 * location / hStack.width)), 5)
    self.rating = Int(rating)
  }
  
}
