import UIKit

/* ======================================================================
 * This is a dummy class used to demo using associatedObjects, both
 * hanging on a viewcontroller and also using associatedObjects on it self.
 * ====================================================================== */
@objc
class Dummy: NSObject {

    var num: Int {
        set {
            associatedObjects?["num"] = newValue
        }
        get {
            if let num = associatedObjects?["num"] as? Int {
                return num
            }
            return 0
        }
    }

    deinit {
        Debug.info("† deinit: \(String(describing: type(of: self)))")
    }

    override init() {
        super.init()
        Debug.info("init: \(String(describing: type(of: self)))")
    }

}

// ----------------------------------------------------------------------

class AssociatedViewController: UIViewController {

    @IBOutlet weak var target: UIView!
    
    deinit {
        Debug.info("† deinit: \(String(describing: type(of: self)))")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.setFullContext([
            "title": "Associated",
            "dummy": "empty"
        ])
        
        let v = self.view.viewWithTag(110)
        v?.frame.origin.x = 300*(CGFloat(arc4random() % 32768) / 32768.0)
        v?.frame.origin.y = 600*(CGFloat(arc4random() % 32768) / 32768.0)
    }

    override func viewDidAppear(_ animated: Bool) {
        presentsCallout(string: "callout-1", target: target)
    }
    
    func dummy() -> Dummy {
        if let dummy = self.associatedObjects?["dummy"] as? Dummy {
            return dummy
        } else {
            let dummy = Dummy()
            self.associatedObjects?["dummy"] = dummy
            return dummy
        }
    }

    @IBAction func down(_ sender: Any) {
        dummy().num = dummy().num - 1
        view.setContextValue("\(dummy().num)", forKey: "dummy")
    }

    @IBAction func up(_ sender: Any) {
        dummy().num = dummy().num + 1
        view.setContextValue("\(dummy().num)", forKey: "dummy")
    }
}
