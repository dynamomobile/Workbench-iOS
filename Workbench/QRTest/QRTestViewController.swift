import UIKit

class QRTestViewController: UIViewController {

    @IBOutlet weak var ballView: UIView!

    var ballPosition = CGPoint.zero
    var ballVelocity = CGPoint.zero
    var ballSize = CGFloat(0)
    var delay = 40

    var screenWidth: CGFloat!
    var screenHeight: CGFloat!

    deinit {
        Debug.info("† deinit: \(String(describing: type(of: self)))")
    }

    func setupParts() {
        ballPosition = .zero
        ballVelocity = .zero
        delay = 40

        screenWidth = view.bounds.width
        screenHeight = view.bounds.height
        ballSize = screenWidth/10.0

        // Get some possible QR code data available in AppSchemeData
        // codestep-7DBB4E08-23EA-43FF-8635-52AAEB59F93A Check App Scheme Data
        if let color = AppSchemeData.shared.lookupColorBy(name: "color") {
            ballView.backgroundColor = color
        }

        if let str = AppSchemeData.shared.lookupStringBy(name: "size") {
            switch str {
            case "big":
                ballSize *= 2
            case "small":
                ballSize /= 2
            default:
                break
            }
        }

        if AppSchemeData.shared.lookupBoolBy(name: "fast") == true {
            delay = 20
        }

        let size = CGSize(width: ballSize, height: ballSize)
        ballView.frame.size = size
        ballView.roundedCornerRadius = "\(ballSize/2.0)"
        ballView.center.x = screenWidth/2
        ballView.center.y = screenHeight*CGFloat(1-1/Float.goldenRatio)
        ballPosition = ballView.center
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // codestep-0A55E47B-4BBE-436C-8E4B-1B763CA43D23 Register for App Scheme Updates
        AppSchemeData.shared.register(observer: self) { [weak self] in
            self?.setupParts()
        }

        setupParts()
        animate()
    }

    func animate() {
        DispatchQueue.onMain(after: delay) { [weak self] in
            self?.updateBallPosition()
            self?.animate()
        }
    }

    func updateBallPosition() {
        ballPosition += ballVelocity
        if ballPosition.x > screenWidth-ballSize/2.0 {
            ballPosition.x = screenWidth-ballSize/2.0
            ballVelocity.x = -ballVelocity.x
        } else if ballPosition.x < -screenWidth+ballSize/2.0 {
            ballPosition.x = -screenWidth+ballSize/2.0
            ballVelocity.x = -ballVelocity.x
        }
        if ballPosition.y > screenHeight-ballSize/2.0 {
            ballPosition.y = screenHeight-ballSize/2.0
            ballVelocity.y = -ballVelocity.y
        } else if ballPosition.y < -screenHeight+ballSize/2.0 {
            ballPosition.y = -screenHeight+ballSize/2.0
            ballVelocity.y = -ballVelocity.y
        }
        ballVelocity.y += 1.0
        ballView.center = ballPosition
    }

}
