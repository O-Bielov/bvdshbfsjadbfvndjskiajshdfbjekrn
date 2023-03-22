//
//  FAQQuestionCell.swift

//
//    on 29.10.2021.
//

import UIKit
import HandyText

final class FAQQuestionCell: UICollectionViewCell {
    
  var didRequestViewMore: ((FAQQuestionCell, FAQ.Question) -> Void)?
  
  private (set) var question: FAQ.Question!
  
  private let titleLabel = UILabel()
  private let textLabel = UILabel()
  private var viewMoreView: UIView!
  private var enclosureIndicator = EnclosureIndicator()
  private let vStack = UIStackView()
  private var firstRow: UIView!
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    setup()
  }
  
  required init?(coder: NSCoder) {
    fatalError()
  }
  
  func display(_ item: FAQItem) {
    guard let question = item as? FAQ.Question else { return }
    self.question = question
    titleLabel.attributedText = question.title.withStyle(.faqTitle)
    textLabel.attributedText = question.answer.withStyle(.faqAnswer)
  }
  
  func heightAtWidth(_ width: CGFloat, with object: FAQItem, isCompact: Bool) -> CGFloat {
//    let minInstanceHeight: CGFloat = 56.0
    
    frame = .init(x: .zero, y: .zero, width: width, height: 50.0)
    
    layoutIfNeeded()

    if isCompact {
      display(object)
      var labelHeight = firstRow.systemLayoutSizeFitting(.init(width: titleLabel.width, height: .zero), withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel).height
      
      labelHeight += 20.0
      
      return labelHeight

    }
    
    display(object)
    frame = .init(x: .zero, y: .zero, width: width, height: 50.0)
    
    layoutIfNeeded()

    
    let stackHeight = vStack.systemLayoutSizeFitting(
      .init(width: width - .margin * 2.0,
            height: .zero),
      withHorizontalFittingPriority: .required,
      verticalFittingPriority: .fittingSizeLevel).height
    
    return stackHeight + 10.0 + .margin
  }
  
  override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
    super.apply(layoutAttributes)
    
    let attrs = layoutAttributes as! FAQLayoutAttributes
    let isCompact = attrs.isCompact

    backgroundColor = attrs.isCompact
    ? .hex("E8EBF2").withAlphaComponent(0.1)
    : .hex("E8EBF2").withAlphaComponent(0.2)
    
    textLabel.alpha = isCompact ? .zero : 1.0
    viewMoreView.alpha = isCompact ? .zero : 1.0
    
    enclosureIndicator.setMode(attrs.isCompact ? .closed : .opened, animated: true)
  }
  
}

private extension FAQQuestionCell {
  
  func setup() {
    let vStack = with(vStack) {
      $0.axis = .vertical
    }.add(to: self)
      .pinToSuperview(leading: .margin, trailing: .margin, top: 10.0)
    
    let firstRow = [titleLabel, enclosureIndicator.centerYWrapped()].makeHStack(spacing: 10.0)
    
    firstRow.snp.makeConstraints {
      $0.height.greaterThanOrEqualTo(36.0)
    }
    
    self.firstRow = firstRow
    firstRow.add(to: vStack)
    
    vStack.addSpace(18.0)
    
    titleLabel.numberOfLines = 0
    textLabel.numberOfLines = 0
    
    textLabel.add(to: vStack)
    
    vStack.addSpace(8.0)
    
    let viewMoreButton = with(UIButton()) {
      $0 |> UIStyle.splashEffect
      $0.addTouchAction { [weak self] in
        guard let self = self else { return }
        self.didRequestViewMore?(self, self.question)
      }
      let style = TextStyle(font: .neurial)
        .medium()
        .size(15.0)
        .foregroundColor(.white)
        .opacity(0.4)
      $0.setAttributedTitle(
        "faq.action.view_more"
          .localized
          .withStyle(style), for: .normal)
    }
      
      let viewMoreStack = [
        viewMoreButton,
        with(UIView()) {
          $0.constrainHeight(to: 1.0)
          $0.backgroundColor = .white.withAlphaComponent(0.3)
        }
      ].makeVStack()
    
    let viewMoreRow = UIView()
    viewMoreStack.add(to: viewMoreRow)
      .pinToSuperview(leading: .zero, top: .zero, bottom: .zero)
    
    viewMoreView = viewMoreRow
    
    viewMoreRow.add(to: vStack)
  }
  
}
