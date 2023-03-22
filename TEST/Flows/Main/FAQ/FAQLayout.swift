//
//  FAQLayout.swift

//
//    on 28.10.2021.
//

import UIKit

protocol FAQLayoutDataSource: AnyObject {
  
  func layout(_ layout: FAQLayout, heightForItemAt indexPath: IndexPath,
              withWidth width: CGFloat) -> CGFloat
  func layout(_ layout: FAQLayout, isChapterAt indexPath: IndexPath) -> Bool
  func layout(_ layout: FAQLayout, isQuestionCompactAt indexPath: IndexPath) -> Bool
  func layout(_ layout: FAQLayout, isChapterFoldedAt index: Int) -> Bool
  
}

final class FAQLayout: UICollectionViewLayout {
 
  weak var dataSource: FAQLayoutDataSource!
  
  private var attributes = [FAQLayoutAttributes]()
  private var invalidatedAttributes = [FAQLayoutAttributes]()
  
  
  override func invalidateLayout() {
    invalidatedAttributes = attributes
  }
  
  override func prepare() {
    guard let collectionView = collectionView else { return }
    
    var allAttributes = [FAQLayoutAttributes]()
    
    let headerAttrs = FAQLayoutAttributes(forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, with: .init(index: 0))
    
    headerAttrs.frame = .init(x: .zero, y: .zero, width: collectionView.width, height: 120.0)
    
    allAttributes.append(headerAttrs)
    
    let countOfItems = collectionView.numberOfItems(inSection: 0)
    
    var currentChapterIndex = -1
    
    for index in 0..<countOfItems {
      let indexPath = IndexPath(item: index, section: 0)
      let attrs = FAQLayoutAttributes(forCellWith: indexPath)
      attrs.isChapter = dataSource.layout(self, isChapterAt: indexPath)
      
      if attrs.isChapter {
        currentChapterIndex += 1
      }
      
      if attrs.isChapter {
        attrs.isCompact = dataSource.layout(self, isChapterFoldedAt: currentChapterIndex)
      } else {
        attrs.isCompact = dataSource.layout(self, isQuestionCompactAt: indexPath)
      }
      
      var cellHeight: CGFloat
      
      var width = collectionView.width - 32.0
      if !attrs.isChapter {
        width -= 20.0
      }
      
      cellHeight = dataSource.layout(self, heightForItemAt: indexPath, withWidth: width)
            
      let currentMaxY = allAttributes.last?.frame.maxY ?? .zero
      
      attrs.frame = .init(
        x: .zero,
        y: currentMaxY,
        width: collectionView.width,
        height: cellHeight)
      
      allAttributes.append(attrs)
      
    }
    
    addSpacesTo(attrs: allAttributes)
    trim(attrs: allAttributes)
    
    attributes = allAttributes
  }
  
  override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
    attributes // TODO: optimize
  }
  
  override var collectionViewContentSize: CGSize {
    .init(width: collectionView?.width ?? .zero,
          height: (attributes.last?.frame.maxY ?? .zero) + 30.0)
    
  }

}

private extension FAQLayout {
  
  func addSpacesTo(attrs: [FAQLayoutAttributes]) {
    attrs.makePairs().forEach { top, bottom in
      guard bottom.frame.height != .zero else { return }
      bottom.frame.origin.y = top.frame.maxY + (top.isChapter == bottom.isChapter ? 10.0 : 20.0)
    }
  }
  
  func trim(attrs: [FAQLayoutAttributes]) {
    attrs.forEach {
      $0.frame.trim(left: 16.0, right: 16.0)
      if !$0.isChapter {
        $0.frame.trim(left: 20.0)
      }
    }
  }
  
}

final class FAQLayoutAttributes: UICollectionViewLayoutAttributes {
  
  private var uid = UUID()
  var isChapter = true
  var isCompact = true
  
  override func copy(with zone: NSZone? = nil) -> Any {
    let copy = super.copy(with: zone) as! FAQLayoutAttributes
    copy.isChapter = isChapter
    copy.isCompact = isCompact
    copy.uid = self.uid
    
    return copy
  }
  
  override func isEqual(_ object: Any?) -> Bool {
    guard let other = object as? FAQLayoutAttributes else { return false }
    return uid == other.uid
    
  }
  
}
