import UIKit

class QRTestViewController: UIViewController {

    @IBOutlet weak var ballView: UIView!

    var ballPosition = CGPoint(x: 0, y: 0)
    var ballVelocity = CGPoint(x: 0, y: 0)
    var ballSize = CGFloat(0)

    var screenWidth: CGFloat!
    var screenHeight: CGFloat!

    deinit {
        Debug.info("† deinit: \(String(describing: type(of: self)))")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        screenWidth = view.bounds.width
        screenHeight = view.bounds.height
        ballSize = screenWidth/10.0

        var delay = 40

        // Get some possible QR code data available in AppSchemeData
        if let color = AppSchemeData.shared.lookupColorBy(name: "color") {
            ballView.backgroundColor = color
        }

        if let str = AppSchemeData.shared.lookupStringBy(name: "string") {
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

        updateBallPosition(delay: delay)
    }

    func updateBallPosition(delay: Int) {
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
        DispatchQueue.onMain(after: delay) { [weak self] in
            self?.updateBallPosition(delay: delay)
        }
    }

}
