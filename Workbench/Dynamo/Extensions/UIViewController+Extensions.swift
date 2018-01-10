import UIKit

extension UIViewController {

    private static var screenSnapshot: UIView?

    static func prepareFadeScreen() {
        if let snapshotView = UIScreen.screens.first?.snapshotView(afterScreenUpdates: false) {
            screenSnapshot = snapshotView
        }
    }

    func fadeScreen(duration: TimeInterval = 1.0) {
        if let snapshotView = UIViewController.screenSnapshot {
            view.addSubview(snapshotView)
            UIView.animate(withDuration: duration, animations: {
                snapshotView.alpha = 0
                snapshotView.frame = snapshotView.frame.insetBy(dx: 1, dy: 1) // workaround to get fade working
            }, completion: { (_) in
                snapshotView.removeFromSuperview()
                UIViewController.screenSnapshot = nil
            })
        }
    }

}
