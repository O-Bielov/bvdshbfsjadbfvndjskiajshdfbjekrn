//
//  RemoteSourceImageView.swift

//
//    on 09.06.2021.
//

import SDWebImage

final class RemoteSourceImageView: UIView {
  
  private let imageView = UIImageView()
  private let placeholderView = UIView()
  private let placeholderImageView = UIImageView()
  
  override var contentMode: UIView.ContentMode {
    get { imageView.contentMode }
    set { imageView.contentMode = newValue }
  }
  
  var placeholderImage: UIImage? {
    didSet {
      placeholderImageView.image = placeholderImage
    }
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    setup()
  }
  
  required init?(coder: NSCoder) {
    fatalError()
  }
  
  func setImage(with urlString: String) {
    guard !urlString.isEmpty else { return }
    imageView.image = nil
    imageView.alpha = 0.0
    placeholderView.alpha = 1.0
    if let url = URL(string: urlString) {
      setImageWithUrl(url)
    } else {
      imageView.sd_cancelCurrentImageLoad()
    }
  }
  
}

private extension RemoteSourceImageView {
  
  func setImageWithUrl(_ url: URL) {
    let imageExists = SDImageCache.shared.diskImageDataExists(withKey: url.absoluteString)
    placeholderView.alpha = imageExists ? .zero : 1.0
    imageView.sd_setImage(with: url) { [weak self] image, _, cacheType, _ in
      guard let self = self else { return }
      UIView.animate(withDuration: imageExists ? .zero : 0.2) {
        self.placeholderView.alpha = image != nil ? .zero : 1.0
        self.imageView.alpha = image != nil ? 1.0 : .zero
      }
    }
  }
  
  func setup() {
    with(placeholderView) {
      $0.add(to: self).constrainEdgesToSuperview()
    }
    
    with(placeholderImageView) { logo in
      logo.contentMode = .scaleAspectFit
      logo.add(to: placeholderView)
        .constrainEdgesToSuperview()
    }
    
    with(imageView) {
      $0.alpha = .zero
      $0.add(to: self)
        .constrainEdgesToSuperview()
    }
  }
  
}
