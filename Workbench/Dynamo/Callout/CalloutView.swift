import UIKit

private class CalloutTouchView: UIView {
    
    weak var calloutView: UIView!
    weak var viewController: UIViewController!
    var done = false

    convenience init(viewController: UIViewController) {
        self.init(frame: viewController.view.bounds)
        self.viewController = viewController
        viewController.view.addSubview(self)
    }

    func gotoNextCallout() {
        calloutView?.removeFromSuperview()
        removeFromSuperview()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak viewController] in
            if let viewController = viewController,
                viewController.isBeingDismissed == false {
                viewController.presentCallouts()
            }
        }
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        guard done == false else {
            return nil
        }
        done = true
        DispatchQueue.main.async {
            self.gotoNextCallout()
        }
        return nil
    }
}

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
        set { _ = newValue }
    }

    var calloutString: String? {
        get {
            if let callout = callout,
                callout.contains(":") {
                return Strings.lookup(string: callout.components(separatedBy: ":")[1])
            }
            return nil
        }
        set { _ = newValue }
    }
    
    fileprivate func isShowingCallout() -> Bool {
        for view in self.subviews {
            if view.isKind(of: CalloutView.self) {
                return true
            }
        }
        return false
    }

}

class CalloutView: UIView {

    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var backView: UIView!
    
    let shadowRadius = CGFloat(4)
    let horizontalMargin = CGFloat(20)
    let verticalMargin = CGFloat(8)
    let pointWidth = CGFloat(15)
    let pointHeigth = CGFloat(20)

    var point = CGPoint.zero
    var calloutAboveTarget = false

    deinit {
        Debug.info("† deinit: \(String(describing: type(of: self)))")
    }

    static func resetCallouts() {
        UserDefaults.standard.removeObject(forKey: "CalloutList")
    }
    
    func setTarget(view: UIView) {
        guard superview != nil, view.superview != nil else {
            return
        }
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
                let touchView = CalloutTouchView(viewController: viewController)
                touchView.calloutView = calloutView
                viewController.view.addSubview(calloutView)
                calloutView.setTarget(view: target)
            }
            return calloutView
        }
        return nil
    }

    override func layoutSubviews() {
        guard superview != nil else {
            return
        }
        textLabel.frame.size = CGSize(width: min(280, 2*superview!.bounds.size.width/3), height: 99999)
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
        layer.shadowOpacity = 0.2
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

private func presentCallout(view: UIView) -> UIView? {
    var out: UIView?
    if let calloutID = view.calloutID {
        var calloutList: [String] = []
        if let list = UserDefaults.standard.object(forKey: "CalloutList") as? [String] {
            calloutList = list
        }
        if calloutList.contains(calloutID) == false {
            out = view
        }
    }
    for view in view.subviews {
        if let found = presentCallout(view: view),
            let calloutID = found.calloutID {
            if out == nil || out?.calloutID?.compare(calloutID) == .orderedDescending {
                out = found
            }
        }
    }
    return out
}

extension UIViewController {
    
    func isShowingCallout() -> Bool {
        return view.isShowingCallout()
    }
    
    func presentCallouts() {
        guard view != nil else {
            return
        }
        if let found = Workbench.presentCallout(view: view!),
            let calloutID = found.calloutID,
            let calloutString = found.calloutString {
            var calloutList: [String] = []
            if let list = UserDefaults.standard.object(forKey: "CalloutList") as? [String] {
                calloutList = list
            }
            calloutList.append(calloutID)
            UserDefaults.standard.set(calloutList, forKey: "CalloutList")
            CalloutView.makeCallout(string: Strings.lookup(string: calloutString),
                                    target: found,
                                    viewController: self)
        }
    }
    
}
