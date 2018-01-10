import UIKit

@IBDesignable
class ResponseButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addTarget(self, action: #selector(detectEvent(_:)), for: .allTouchEvents)
    }

    @objc func detectEvent(_ sender: Any) {
        DispatchQueue.main.async {
            if self.isHighlighted {
                self.layer.opacity = self.layer.borderWidth > 0.0 ? 0.2 : 0.6
            } else {
                self.layer.opacity = 1.0
            }
        }
    }

}
