import UIKit

private class TableViewDataSourceParasite: NSObject, UITableViewDataSource {

    let cellIdentifier: String!
    let contextKey: String!

    deinit {
        Debug.info("† deinit: \(String(describing: type(of: self)))")
    }

    init(cellIdentifier: String, contextKey: String) {
        self.cellIdentifier = cellIdentifier
        self.contextKey = contextKey
    }

    // MARK: - Table View DataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let arr = tableView.contextValue(forKey: contextKey) as? [Any] {
            return arr.count
        }
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
        if let arr = tableView.contextValue(forKey: contextKey) as? [[String: Any]] {
            cell?.setFullContext(arr[indexPath.row])
        }
        return cell!
    }

}

extension UIView {

    static let contextPointerBase        = UnsafeRawPointer("contextPointerBase")
    static let contextKey                = contextPointerBase+0
    static let viewControllerKey         = contextPointerBase+1
    static let parentViewControllerKey   = contextPointerBase+2
    static let textChangeNotificationKey = contextPointerBase+3
    static let tableViewParasiteKey      = contextPointerBase+4

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
            if self.isKind(of: UITableView.self),
                let tableView = self as? UITableView,
                let newValue = newValue {
                var parts = newValue.components(separatedBy: "|")
                let key = parts[0]
                let extra = parts.count > 1 ? parts[1] : nil
                let cellIdentifier = extra ?? "Cell"
                let parasite = TableViewDataSourceParasite(cellIdentifier: cellIdentifier, contextKey: key)
                tableView.dataSource = parasite
                objc_setAssociatedObject(self,
                                         UIView.tableViewParasiteKey,
                                         parasite,
                                         .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
            if self.isKind(of: UISlider.self),
                let control = self as? UISlider {
                control.addTarget(self, action: #selector(UISlider.wb_contextSliderUpdate), for: .valueChanged)
                control.wb_contextSliderUpdate(control)
            }
            if self.isKind(of: UITextView.self) {
                let proto = NotificationCenter.default.addObserver(forName: .UITextViewTextDidChange,
                                                                   object: self,
                                                                   queue: nil) { (notification) in
                    if let textView = notification.object as? UITextView,
                        let parent = textView.superview,
                        let context = textView.context,
                        let text = textView.text {
                        parent.setContextValue(text, forKey: context)
                    }
                }
                objc_setAssociatedObject(self,
                                         UIView.textChangeNotificationKey,
                                         proto,
                                         .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
            if self.isKind(of: UITextField.self) {
                let proto = NotificationCenter.default.addObserver(forName: .UITextFieldTextDidChange,
                                                                   object: self,
                                                                   queue: nil) { (notification) in
                    if let textField = notification.object as? UITextField,
                        let parent = textField.superview,
                        let context = textField.context,
                        let text = textField.text {
                        parent.setContextValue(text, forKey: context)
                    }
                }
                objc_setAssociatedObject(self,
                                         UIView.textChangeNotificationKey,
                                         proto,
                                         .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
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
        if self.isKind(of: UITextView.self), let textView = self as? UITextView,
            let contextValue = contextValue(forKey: key) as? ContextTransformer {
            textView.text = contextValue.toString(extra: extra)
        }
        if self.isKind(of: UITextField.self), let textField = self as? UITextField,
            let contextValue = contextValue(forKey: key) as? ContextTransformer {
            textField.text = contextValue.toString(extra: extra)
        }
        if self.isKind(of: UITableView.self), let tableView = self as? UITableView {
            tableView.reloadData()
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

extension UISlider {

    @objc
    func wb_contextSliderUpdate(_ sender: UISlider!) {
        if let parent = self.superview,
            let context = self.context {
            parent.setContextValue(sender.value, forKey: context)
        }
    }

}
