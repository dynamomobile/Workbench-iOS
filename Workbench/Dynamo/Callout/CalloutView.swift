import UIKit

class CalloutView: UIView {

    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var backView: UIView!
    
    let shadowRadius = CGFloat(8)
    let horizontalMargin = CGFloat(20)
    let verticalMargin = CGFloat(8)
    let pointWidth = CGFloat(15)
    let pointHeigth = CGFloat(20)

    var point = CGPoint.zero
    var calloutAboveTarget = false

    deinit {
        Debug.info("† deinit: \(String(describing: type(of: self)))")
    }

    func setTarget(view: UIView) {
        let center = view.center
        var centerTop = view.superview!.convert(center, to: nil)
        var centerBottom = centerTop
        centerTop.y -= view.frame.size.height/2
        centerBottom.y += view.frame.size.height/2
        let screenHeight = UIScreen.main.bounds.size.height
        if screenHeight - centerTop.y < centerBottom.y {
            calloutAboveTarget = true
            point = superview!.convert(centerTop, from: nil)
        } else {
            point = superview!.convert(centerBottom, from: nil)
        }
        setNeedsLayout()
        setNeedsDisplay()
    }
    
    static func makeCallout(string: String, target: UIView) -> CalloutView? {
        if let calloutView = Bundle.main.loadNibNamed("CalloutView",
                                                      owner: nil,
                                                      options: nil)?.first as? CalloutView {
            calloutView.textLabel.text = string
            DispatchQueue.main.async {
                calloutView.setTarget(view: target)
            }
            return calloutView
        }
        return nil
    }

    override func layoutSubviews() {
        textLabel.frame.size = CGSize(width: 2*superview!.bounds.size.width/3, height: 99999)
        textLabel.sizeToFit()
        var rect = CGRect(origin: CGPoint(x: horizontalMargin, y: verticalMargin),
                          size: textLabel.frame.size)
        textLabel.frame = rect
        rect.origin.x = shadowRadius
        rect.origin.y = pointHeigth
        rect.size.width += 2*horizontalMargin
        rect.size.height += 2*verticalMargin
        backView.frame = rect
        rect.size.width += 2*shadowRadius
        rect.size.height += 2*pointHeigth
        frame.size = rect.size
        var x = point.x - rect.size.width/2
        if x < 0 {
            x = 0
        } else if x + rect.size.width > superview!.frame.width {
            x = superview!.frame.width - rect.size.width
        }
        if calloutAboveTarget {
            frame.origin = CGPoint(x: x, y: point.y - rect.size.height)
        } else {
            frame.origin = CGPoint(x: x, y: point.y)
        }
        self.layer.shadowRadius = shadowRadius
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.layer.shadowOpacity = 0.4
    }
    
    override func draw(_ rect: CGRect) {
        backView.backgroundColor?.setFill()
        let path = UIBezierPath()
        var p = point - frame.origin
        if calloutAboveTarget {
            path.move(to: p + CGPoint(x: 0, y: -2))
            p += CGPoint(x: pointWidth, y: -pointHeigth)
            path.addLine(to: p)
            p += CGPoint(x: 0, y: -pointHeigth)
            path.addLine(to: p)
            p += CGPoint(x: -2*pointWidth, y: 0)
            path.addLine(to: p)
            p += CGPoint(x: 0, y: pointHeigth)
            path.addLine(to: p)
            path.close()
            path.fill()
        } else {
            path.move(to: p + CGPoint(x: 0, y: 2))
            p += CGPoint(x: pointWidth, y: pointHeigth)
            path.addLine(to: p)
            p += CGPoint(x: 0, y: pointHeigth)
            path.addLine(to: p)
            p += CGPoint(x: -2*pointWidth, y: 0)
            path.addLine(to: p)
            p += CGPoint(x: 0, y: -pointHeigth)
            path.addLine(to: p)
            path.close()
            path.fill()
        }
    }
    
}

extension UIViewController {

    func presentsCallout(string: String, target: UIView) {
        if let calloutView = CalloutView.makeCallout(string: Strings.lookup(string: string),
                                                     target: target) {
            view.addSubview(calloutView)
        }
    }
    
}
