import UIKit

@IBDesignable
class AnimatedCheckmarkView: UIView {

    @IBInspectable var drawCircle: Bool = true
    @IBInspectable var checkmarkColor: UIColor!
    @IBInspectable var circleOnColor: UIColor!
    @IBInspectable var circleOffColor: UIColor!
    @IBInspectable var duration: CGFloat = 0.4

    private var willAnimate = false
    private var _isChecked: Bool = false
    var isChecked: Bool {
        set {
            if _isChecked != newValue {
                _isChecked = newValue
                removeSublayers()
                if newValue {
                    self.animate()
                }
                self.setNeedsDisplay()
            }
        }
        get {
            return _isChecked
        }
    }

    func getCheckmarkPath() -> UIBezierPath {
        let rect = bounds.squareFit()
        let path = UIBezierPath()

        func pos(x: CGFloat, y: CGFloat) -> CGPoint {
            return CGPoint(x: rect.origin.x + rect.width*x, y: rect.origin.y + rect.width*y)
        }

        path.move(to: pos(x: 0.31, y: 0.5))
        path.addLine(to: pos(x: 0.42, y: 0.61))
        path.addLine(to: pos(x: 0.685, y: 0.345))

        return path
    }

    func drawCheckmark() {
        let rect = bounds.squareFit()
        let path = getCheckmarkPath()
        path.lineWidth = rect.size.width/19.0
        if checkmarkColor != nil {
            checkmarkColor.setStroke()
        } else {
            UIColor.white.setStroke()
        }
        path.stroke()
    }

    func removeSublayers() {
        for layer in layer.sublayers ?? [] {
            layer.removeFromSuperlayer()
        }
    }

    func animate() {
        removeSublayers()

        willAnimate = true
        let rect = bounds.squareFit()

        let checkmarkLayer = CAShapeLayer()

        checkmarkLayer.fillColor = UIColor.clear.cgColor
        if checkmarkColor != nil {
            checkmarkLayer.strokeColor = checkmarkColor.cgColor
        } else {
            checkmarkLayer.strokeColor = UIColor.white.cgColor
        }
        checkmarkLayer.lineWidth = rect.size.width/16.0

        let animation: CABasicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0.0
        animation.toValue = 1.0
        animation.duration = CFTimeInterval(duration)
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        checkmarkLayer.add(animation, forKey: "strokeEnd")

        checkmarkLayer.path = getCheckmarkPath().cgPath

        layer.addSublayer(checkmarkLayer)
    }

    override func draw(_ rect: CGRect) {
        if drawCircle {
            if isChecked && circleOnColor != nil {
                circleOnColor.setFill()
            } else if !isChecked && circleOffColor != nil {
                circleOffColor.setFill()
            }
            bounds.circlePath().fill()
        }

        #if !TARGET_INTERFACE_BUILDER
            if isChecked &&  !willAnimate {
                drawCheckmark()
            }
            willAnimate = false
        #else
            drawCheckmark()
        #endif
    }

}
