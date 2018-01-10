import UIKit

class MoreViewController: UIViewController {

    deinit {
        Debug.info("† deinit: \(String(describing: type(of: self)))")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
