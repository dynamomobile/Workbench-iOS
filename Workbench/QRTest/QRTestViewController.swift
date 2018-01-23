import UIKit

class QRTestViewController: UIViewController {

    deinit {
        Debug.info("† deinit: \(String(describing: type(of: self)))")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        if let color = AppSchemeData.shared.lookupColorBy(name: "color") {
            view.backgroundColor = color
        }
    }

}
