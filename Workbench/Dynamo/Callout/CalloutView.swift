import UIKit

extension UIView {

    static let calloutPointerBase = UnsafeRawPointer("calloutPointerBase")

    @IBInspectable
    dynamic var callout: String? {
        get {
            return objc_getAssociatedObject(self, UIView.calloutPointerBase) as? String
        }
        set {
            objc_setAssociatedObject(self, UIView.calloutPointerBase, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    var calloutID: String? {
        get {
            if let callout = callout,
                callout.contains(":") {
                return callout.components(separatedBy: ":")[0]
            }
            return nil
        }
        set {
        }
    }

    var calloutString: String? {
        get {
            if let callout = callout,
                callout.contains(":") {
                return Strings.lookup(string: callout.components(separatedBy: ":")[1])
            }
            return nil
        }
        set {
        }
    }
}

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
        centerTop.y -= view.frame.size.height/2 + 5
        centerBottom.y += view.frame.size.height/2 - 5
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
    
    @discardableResult
    static func makeCallout(string: String,
                            target: UIView,
                            viewController: UIViewController) -> CalloutView? {
        if let calloutView = Bundle.main.loadNibNamed("CalloutView",
                                                      owner: nil,
                                                      options: nil)?.first as? CalloutView {
            calloutView.textLabel.text = string
            DispatchQueue.main.async {
                viewController.view.addSubview(calloutView)
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
        if point.x < pointWidth + shadowRadius {
            point.x = pointWidth + shadowRadius
        }
        if point.x > superview!.frame.width - (pointWidth + shadowRadius) {
            point.x = superview!.frame.width - (pointWidth + shadowRadius)
        }
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
        layer.shadowRadius = shadowRadius
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowOpacity = 0.4
        layer.shouldRasterize = true
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

@discardableResult
private func presentCallout(viewController: UIViewController, view: UIView) -> Bool {
    if view.calloutID != nil {
        CalloutView.makeCallout(string: Strings.lookup(string: view.calloutString!),
                                target: view,
                                viewController: viewController)
        return true
    }
    for view in view.subviews {
        if presentCallout(viewController: viewController, view: view) {
            return true
        }
    }
    return false
}

extension UIViewController {
    
    func presentCallout() {
        Workbench.presentCallout(viewController: self, view: view!)
    }
    
}