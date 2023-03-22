//
//  AuthorView.swift

//
//    on 20.10.2021.
//

import UIKit

final class AuthorView: UIView {
  
  var didRequestAuthorPage: ((AuthorView) -> Void)?
  var didRequestShareAuthor: ((AuthorView) -> Void)?
  
  private let avatarView = RemoteSourceImageView()
  private let nameButton = UIButton()
  private let idLabel = UILabel()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    setup()
  }
  
  required init?(coder: NSCoder) {
    fatalError()
  }
  
  func showAuthor(_ author: Creator) {
    author.imageUrl.map {
      avatarView.setImage(with: $0)
    }
    nameButton.setAttributedTitle(
      author.name
        .withStyle(
          .init(font: .neurial)
            .size(14.0)
            .medium()
            .foregroundColor(.white)),
      for: .normal)
    
    idLabel.attributedText = author.tiktokId
      .withStyle(
        .init(font: .neurial)
          .size(14.0)
          .regular()
          .foregroundColor(.white))
  }
  
}

private extension AuthorView {
  
  func setup() {
    constrainHeight(to: 44.0)
    
    with(avatarView) {
      $0.contentMode = .scaleAspectFill
      with($0.layer) {
        $0.cornerRadius = 15.0
        $0.masksToBounds = true
      }
    }.constrainWidth(to: 30.0)
      .aspectRatio(1.0)
    
    with(nameButton) {
      $0.setTitleColor(.white, for: .normal)
      $0.constrainHeight(to: 44.0)
      $0.addTouchAction { [weak self] in
        guard let self = self else { return }
        self.didRequestAuthorPage?(self)
      }
    }
    
    idLabel.textColor = .white
    
    let shareButton = with(ButtonWithIcon()) {
      $0.icon = #imageLiteral(resourceName: "icon.share")
      $0.iconDiameter = 12.0
      $0.addTouchAction { [weak self] in
        self.map { $0.didRequestShareAuthor?($0) }
      }
    }.constrainWidth(to: 44.0)
      .aspectRatio(1.0)
    
    let infoButton = [avatarView, nameButton, idLabel]
      .makeHStack(spacing: 10.0) { $0.alignment = .center }
      .makeButton { [weak self] in self.map { $0.didRequestAuthorPage?($0) }}
    
    [infoButton,
     .spacer(),
     shareButton]
      .makeHStack(spacing: 10.0) {
      $0.alignment = .center
    }.add(to: self)
      .constrainEdgesToSuperview()
    
    nameButton.setContentCompressionResistancePriority(.required, for: .horizontal)
  }
  
}
