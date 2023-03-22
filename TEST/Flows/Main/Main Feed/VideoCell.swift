//
//  VideoCell.swift

//
//    on 20.10.2021.
//

import UIKit
import AVKit
import NVActivityIndicatorView

final class VideoCell: UICollectionViewCell {
  
  var didRequestAuthorPage: ((VideoCell) -> Void)?
  var didRequestShareAuthor: ((VideoCell) -> Void)?
  
  private let authorView = AuthorView()
  private let progressBar = VideoProgressBar()
  private lazy var playerLayer: AVPlayerLayer = .init(player: player)
  private var activityIndicator: NVActivityIndicatorView!
  private var rateObservation: NSKeyValueObservation?
  
  private let player = AVQueuePlayer()
  private var looper: AVPlayerLooper!
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    setup()
  }
  
  required init?(coder: NSCoder) {
    fatalError()
  }
  
  func stopPlayback() {
    player.pause()
    looper = nil
  }
  
  func pause() {
    player.pause()
  }
  
  func restorePlayback() {
    player.play()
  }
  
  func showVideo(_ video: Video) {
    authorView.showAuthor(video.creator)
    progressBar.progress = .zero
    
    let url = URL(string: video.downloadUrl)!
    let item = AVPlayerItem(url: url)
    
    looper = .init(player: player, templateItem: item)
        
    #if !DEBUG
    player.play()
    #endif
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    playerLayer.frame = bounds
  }
  
}

private extension VideoCell {
  
  func updateActivityIndicatorVisibility() {
    let currentSeconds = player.currentItem?.currentTime().seconds ?? .zero
            
    let isPlaying = currentSeconds > .zero
    
    self.activityIndicator.isHidden = isPlaying

  }
  
  func setup() {
    backgroundColor = .black

    with(playerLayer) {
      $0.videoGravity = .resizeAspectFill
      contentView.layer.addSublayer($0)
    }
    
    rateObservation = player.observe(\.status) { [weak self] player, _ in
      guard let self = self else { return }
      self.updateActivityIndicatorVisibility()
    }
    
    player.addPeriodicTimeObserver(
      forInterval: .init(seconds: 1.0, preferredTimescale: 1),
      queue: .main) { [weak self] time in
        guard let self = self, let item = self.player.currentItem else { return }
        
        self.updateActivityIndicatorVisibility()
        
        guard !(item.duration.seconds.isNaN || time.seconds.isNaN) else { return }
        
        let currentSeconds = time.seconds
        let totalSeconds = item.duration.seconds
                
        let newProgress = currentSeconds / totalSeconds
        let shouldAnimate = newProgress > self.progressBar.progress
        
        UIView.animate(withDuration: shouldAnimate ? 1.0 : .zero,
                       delay: .zero,
                       options: [.curveLinear],
                       animations: {
          self.progressBar.progress = newProgress
        }, completion: { _ in })
      }
    
    with(GradientView()) {
      $0.direction = .vertical
      $0.from = .black.withAlphaComponent(0.4)
      $0.to = .clear
    }.add(to: contentView)
      .pinToSuperview(leading: .zero, trailing: .zero, top: .zero)
      .constrainHeight(to: 170.0)
    
    with(GradientView()) {
      $0.direction = .vertical
      $0.from = .clear
      $0.to = .black.withAlphaComponent(0.4)
    }.add(to: contentView)
      .pinToSuperview(leading: .zero, trailing: .zero, bottom: .zero)
      .constrainHeight(to: 170.0)
    
    authorView.didRequestAuthorPage = { [weak self] _ in
      guard let self = self else { return }
      self.didRequestAuthorPage?(self)
    }
    
    authorView.didRequestShareAuthor = { [weak self] _ in
      guard let self = self else { return }
      self.didRequestShareAuthor?(self)
    }
    
    [authorView.wrappedWithMargins(leading: 20.0, trailing: 10.0),
     progressBar.wrappedWithMargins(leading: 20.0, trailing: 20.0)
    ].makeVStack(spacing: 7.0)
      .add(to: contentView)
      .pinToSuperview(leading: .zero,
                      trailing: .zero,
                      bottom: UIDevice.safeAreaInsets.bottom == .zero ? 16.0 : 37.0)
    
    with(NVActivityIndicatorView(
      frame: .zero,
      type: .ballClipRotatePulse,
      color: .white.withAlphaComponent(0.3),
      padding: .zero)) {
        self.activityIndicator = $0
        $0.startAnimating()
    }.add(to: self)
    .constrainWidth(to: 50.0)
    .constrainHeight(to: 50.0)
    .pinCenter()
  }
  
}
