//
//  DynamicHeightUpdateBehavior.swift

//
//    on 02.11.2021.
//

import UIKit

public protocol DynamicHeightUpdating: AnyObject {
  
  var needsUpdateHeight: ((DynamicHeightUpdating) -> Void)? { get set }
  
}

public final class DynamicHeightUpdateBehavior: NSObject, CollectionViewBehavior {
  
  public var collectionView: UICollectionView!
    
  public func collectionView(
    _ collectionView: UICollectionView,
    willDisplay cell: UICollectionViewCell,
    forItemAt indexPath: IndexPath) {
      
      (cell as? DynamicHeightUpdating)?.needsUpdateHeight = { [weak collectionView] _ in
        collectionView?.performBatchUpdates(nil) { _ in
//          collectionView?.collectionViewLayout.invalidateLayout()
        }
      }
    }
  
}
