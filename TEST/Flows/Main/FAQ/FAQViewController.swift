//
//  FAQViewController.swift

//
//    on 28.10.2021.
//

import UIKit

final class FAQViewController: UIViewController {
  
  private let module: FAQModule
  private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: FAQLayout())
  
  private let questionCellPrototype = FAQQuestionCell()
  
  private var layout: FAQLayout {
    collectionView.collectionViewLayout as! FAQLayout
  }
  
  init(module: FAQModule) {
    self.module = module
    
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setup()
  }
  
}

extension FAQViewController: UICollectionViewDelegate, UICollectionViewDataSource {
  
  
  func collectionView(_ collectionView: UICollectionView,
                      numberOfItemsInSection section: Int) -> Int {
    module.numberOfItems()
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    if module.isChapter(at: indexPath) {
      let cell: FAQChapterCell = collectionView.dequeueCell(for: indexPath)
      cell.display(module.item(at: indexPath))
      return cell
    } else {
      let cell: FAQQuestionCell = collectionView.dequeueCell(for: indexPath)
      cell.didRequestViewMore = { cell, question in
        if let url = URL(string: question.moreInfoLink), UIApplication.shared.canOpenURL(url) {
          UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
      }
      cell.display(module.item(at: indexPath))
      return cell
    }
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      didSelectItemAt indexPath: IndexPath) {
    if let chapterCell = collectionView.cellForItem(at: indexPath) as? FAQChapterCell {
    let updates = self.module.toggleFoldState(for: chapterCell.chapter)
      collectionView.performBatchUpdates {
      collectionView.deleteItems(at: updates.deletions.map { IndexPath.init(item: $0, section: 0)})
      collectionView.insertItems(at: updates.inserts.map { IndexPath.init(item: $0, section: 0)})
      } completion: { _ in
          
      }
    } else if let questionCell = collectionView.cellForItem(at: indexPath) as? FAQQuestionCell {
      self.module.toggleFoldStateForQuestion(questionCell.question)
      collectionView.performBatchUpdates {
        layout.invalidateLayout()
      } completion: { _ in
        
      }

    }
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      viewForSupplementaryElementOfKind kind: String,
                      at indexPath: IndexPath) -> UICollectionReusableView {
    let view: FAQScreenHeader = collectionView.dequeueSupplementaryView(kind: UICollectionView.elementKindSectionHeader, for: indexPath)
    
    return view
  }
  
}

extension FAQViewController: FAQLayoutDataSource {
  
  func layout(_ layout: FAQLayout,
              heightForItemAt indexPath: IndexPath,
              withWidth width: CGFloat) -> CGFloat {
    let item = module.item(at: indexPath)
    if item is FAQ.Chapter {
      return FAQChapterCell.preferredInstanceHeigh
    } else if let question = item as? FAQ.Question {
      return questionCellPrototype.heightAtWidth(
        width,
        with: module.item(at: indexPath),
        isCompact: !module.isQuestionUnfold(question))
    }
    
    return .zero
  }
  
  func layout(_ layout: FAQLayout,
              isChapterAt indexPath: IndexPath) -> Bool {
    module.isChapter(at: indexPath)
  }
  
  func layout(_ layout: FAQLayout, isQuestionCompactAt indexPath: IndexPath) -> Bool {
    !module.isQuestionUnfold(module.item(at: indexPath) as! FAQ.Question)
  }
  
  func layout(_ layout: FAQLayout, isChapterFoldedAt index: Int) -> Bool {
    module.isChapterFolded(module.faq.chapters[index])
  }
}

private extension FAQViewController {
  
  func setup() {
    addPinkBackButton()

    view.backgroundColor = .darkBackground
    
    with(collectionView) {
      $0.alwaysBounceVertical = true
      $0.backgroundColor = .clear
      $0.delegate = self
      $0.dataSource = self
      $0.registerCellClass(FAQChapterCell.self)
      $0.registerCellClass(FAQQuestionCell.self)
      $0.registerSupplementaryView(FAQScreenHeader.self, kind: UICollectionView.elementKindSectionHeader)
    }.add(to: view)
      .constrainEdgesToSuperview()
    
    layout.dataSource = self
  }
  
}
