//
//  MainFeedModule.swift

//
//    on 20.10.2021.
//

import Foundation

final class MainFeedModule: Module {
  
  let isLoading = Observable(false)
  let videos = Observable<[Video]>([])
  
  override func didMoveToParent() {
    super.didMoveToParent()
    
    loadVideos()
  }
  
}

private extension MainFeedModule {
  
  func loadVideos() {
    isLoading.value = true
        
    let dateFormatter = with(DateFormatter()) {
      $0.dateFormat = "YYYY-MM-dd"
    }
    
    let dateString = dateFormatter.string(from: Date())
    
    requestExecutor.execute(.videos(date: dateString))?
      .completion
      .deliver(on: .main)
      .observe { [weak self] result in
      self?.isLoading.value = false
      switch result {
      case .success(let videos):
        self?.videos.value = videos
      case .failure(let error):
        self?.raise(error)
      }
    }.owned(by: self)
  }
  
}
