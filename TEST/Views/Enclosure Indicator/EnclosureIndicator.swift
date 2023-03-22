//
//  EnclosureIndicator.swift

//
//    on 29.10.2021.
//

import UIKit

final public class EnclosureIndicator: UIView {
    
    public enum Mode {
        case closed, opened
    }
    
    public var mode: Mode = .opened {
        didSet {
            let angle: CGFloat
            switch mode {
            case .closed: angle = 0
            case .opened: angle = -CGFloat.pi + 0.0001
            }
            imageView.transform = CGAffineTransform.init(rotationAngle: angle)
        }
    }
    
    override public var tintColor: UIColor! {
        didSet {
            imageView.tintColor = tintColor
        }
    }
    
  private let imageView = UIImageView(image: .init(named: "enclosure_indicator"))
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    public func setMode(_ mode: Mode, animated: Bool) {
      UIView.animate(withDuration: animated ? .zero : 0.1) {
        self.mode = mode
      }
    }
    
}

private extension EnclosureIndicator {
    
    func setup() {
      constrainWidth(to: 20.0)
      .aspectRatio(1.0)

      with(imageView) {
            $0.contentMode = .center
      }.add(to: self)
        .constrainEdgesToSuperview()
      
      mode = .opened
    }
    
}
