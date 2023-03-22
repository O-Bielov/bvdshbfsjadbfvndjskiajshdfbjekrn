//
//  MainFeedViewController.swift

//
//    on 20.10.2021.
//

import UIKit
import AVFoundation

final class MainFeedViewController: UIViewController {
  
  var didRequestAuthorPage: ((MainFeedViewController, Video) -> Void)?
  var didSelectShowMenu: ((MainFeedViewController) -> Void)?
  
  private let module: MainFeedModule
  
  private let collectionView = UICollectionView(
    frame: .zero,
    collectionViewLayout: UICollectionViewFlowLayout())
  
  private let trailingView = FeedTrailingView()
  
  init(module: MainFeedModule) {
    self.module = module
    
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setup()
    setupBindings()
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    
    pause()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    restorePlayback()
  }
  
}

extension MainFeedViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
  
  func collectionView(_ collectionView: UICollectionView,
                      numberOfItemsInSection section: Int) -> Int {
    module.videos.value.count
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell: VideoCell = collectionView.dequeueCell(for: indexPath)
        
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
    collectionView.size
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      viewForSupplementaryElementOfKind kind: String,
                      at indexPath: IndexPath) -> UICollectionReusableView {
    guard kind == UICollectionView.elementKindSectionFooter else { fatalError() }
    
    let view: FeedTrailingView = collectionView.dequeueSupplementaryView(kind: UICollectionView.elementKindSectionFooter, for: indexPath)
    
    view.didSelectInviteFriend = { [weak self] _ in
      self?.showShareAppDialog()
    }
    
    return view
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      referenceSizeForFooterInSection section: Int) -> CGSize {
    collectionView.size
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      willDisplay cell: UICollectionViewCell,
                      forItemAt indexPath: IndexPath) {
    let cell = cell as! VideoCell
    let video = module.videos.value[indexPath.item]
    cell.showVideo(video)
    cell.didRequestAuthorPage = { [weak self] _ in
      guard let self = self else { return }
      self.didRequestAuthorPage?(self, video)
    }
    
    cell.didRequestShareAuthor = { [weak self] _ in
      self?.showShareAuthorDialog(for: video)
    }
  }
    
  func collectionView(_ collectionView: UICollectionView,
                      didEndDisplaying cell: UICollectionViewCell,
                      forItemAt indexPath: IndexPath) {
    (cell as? VideoCell)?.stopPlayback()
  }
  
}

private extension MainFeedViewController {
  
  private var layout: UICollectionViewFlowLayout {
    collectionView.collectionViewLayout as! UICollectionViewFlowLayout
  }
  
  func setup() {
    try! AVAudioSession.sharedInstance().setCategory(.playback, options: [])

    navigationItem.rightBarButtonItem = .image(.init(named: "icon.settings")!) { [weak self] in
      guard let self = self else { return }
      self.didSelectShowMenu?(self)
    }
    leftAlignedTitle = "feed.screen_title".localized
    
    with(UIImageView(image: UIImage(named: "background.letters"))) {
      $0.contentMode = .scaleAspectFill
    }.add(to: view)
      .constrainEdgesToSuperview()
    
    with(collectionView) {
      $0.showsVerticalScrollIndicator = false
      $0.backgroundColor = .clear
      $0.delegate = self
      $0.dataSource = self
      $0.contentInsetAdjustmentBehavior = .never
      $0.registerCellClass(VideoCell.self)
      $0.registerSupplementaryView(FeedTrailingView.self,
                                   kind: UICollectionView.elementKindSectionFooter)
      $0.isPagingEnabled = true
    }.add(to: view)
      .constrainEdgesToSuperview()
    
    with(layout) {
      $0.minimumLineSpacing = .zero
      $0.scrollDirection = .vertical
    }
  }
  
  func setupBindings() {
    module.isLoading.observe { [weak self] in
      $0
      ? self?.navigationController?.showLoadingView()
      : self?.navigationController?.hideLoadingView()
    }.owned(by: self)
    
    module.videos.observe { [weak self] _ in
      self?.collectionView.reloadData()
    }.owned(by: self)
    
    NotificationCenter.default.addObserver(forName: UIApplication.didEnterBackgroundNotification,
                                           object: nil,
                                           queue: nil) { [weak self] _ in
      self?.pause()
    }
    
    NotificationCenter.default.addObserver(forName: UIApplication.willEnterForegroundNotification,
                                           object: nil,
                                           queue: nil) { [weak self] _ in
      self?.restorePlayback()
    }
  }

  func showShareAuthorDialog(for video: Video) {
    let shareMessage = String(format: "feed.share_author_message_format".localized,
                              video.creator.tiktokId, video.downloadUrl)
    
    showShareDialog(with: shareMessage)
  }
  
  func pause() {
    collectionView.visibleCells.compactMap { $0 as? VideoCell }.forEach { cell in
      cell.pause()
    }
  }
    
  func restorePlayback() {
    let isCurrent = navigationController?.viewControllers.last == self
    
    guard isCurrent else { return }
    
    collectionView.visibleCells.compactMap { $0 as? VideoCell }.forEach { cell in
      cell.restorePlayback()
    }
  }
  
}
