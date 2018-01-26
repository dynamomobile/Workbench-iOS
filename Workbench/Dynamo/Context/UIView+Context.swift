import UIKit

extension UIView {

    static let contextPointerBase      = UnsafeRawPointer("contextPointerBase")
    static let contextKey              = contextPointerBase+0
    static let viewControllerKey       = contextPointerBase+1
    static let parentViewControllerKey = contextPointerBase+2

    // Setup childViewController when loaded from property "viewcontroller" and has parentViewcontroller
    func contextCheckToSetup() {
        if let vc = objc_getAssociatedObject(self, UIView.viewControllerKey) as? UIViewController,
            let parentViewController = objc_getAssociatedObject(self,
                                                                UIView.parentViewControllerKey) as? UIViewController {
            parentViewController.addChildViewController(vc)
            addSubview(vc.view)
            vc.viewDidLoad()
            objc_removeAssociatedObjects(self)
        }
    }

    @IBOutlet var parentViewController: UIViewController? {
        get {
            return objc_getAssociatedObject(self, UIView.parentViewControllerKey) as? UIViewController
        }
        set {
            objc_setAssociatedObject(self, UIView.parentViewControllerKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            contextCheckToSetup()
        }
    }

    @IBInspectable
    dynamic var context: String? {
        get {
            return objc_getAssociatedObject(self, UIView.contextKey) as? String
        }
        set {
            objc_setAssociatedObject(self, UIView.contextKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    @objc
    func updateContext() {
        subviews.forEach { (view) in
            view.updateContext()
        }
        guard let context = context else {
            return
        }
        var parts = context.components(separatedBy: "|")
        guard parts.count > 0 else {
            return
        }
        let key = parts[0]
        let extra = parts.count > 1 ? parts[1] : nil
        if self.isKind(of: UILabel.self), let label = self as? UILabel,
            let contextValue = contextValue(forKey: key) as? ContextTransformer {
            label.text = contextValue.toString(extra: extra)
        }
    }

    @IBInspectable
    dynamic var viewcontroller: String? {
        get {
            return nil
        }
        set {
            if let vc = UIViewController.loadClass(byName: newValue!) {
                vc.view.frame = bounds
                vc.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                objc_setAssociatedObject(self, UIView.viewControllerKey, vc, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
            contextCheckToSetup()
        }
    }

}
