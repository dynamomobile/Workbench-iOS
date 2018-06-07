import UIKit

class CalloutViewController: UIViewController {

    deinit {
        Debug.info("† deinit: \(String(describing: type(of: self)))")
    }

    override func viewDidAppear(_ animated: Bool) {
        presentCallouts()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func resetPressed(_ sender: Any?) {
        CalloutView.resetCallouts()
    }
    
}
