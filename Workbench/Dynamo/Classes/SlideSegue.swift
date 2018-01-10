import UIKit

private func addSlideSegueAnimation(direction: String, storyboard: UIStoryboardSegue) {
    let src = storyboard.source
    let dst = storyboard.destination

    src.view.superview?.insertSubview(dst.view, aboveSubview: src.view)
    var srcTransform: CGAffineTransform!
    switch direction {
    case "up":
        srcTransform = CGAffineTransform(translationX: 0, y: -src.view.frame.size.height)
        dst.view.transform = CGAffineTransform(translationX: 0, y: src.view.frame.size.height)
    case "down":
        srcTransform = CGAffineTransform(translationX: 0, y: src.view.frame.size.height)
        dst.view.transform = CGAffineTransform(translationX: 0, y: -src.view.frame.size.height)
    case "left":
        srcTransform = CGAffineTransform(translationX: -src.view.frame.size.width, y: 0)
        dst.view.transform = CGAffineTransform(translationX: src.view.frame.size.width, y: 0)
    case "right":
        srcTransform = CGAffineTransform(translationX: src.view.frame.size.width, y: 0)
        dst.view.transform = CGAffineTransform(translationX: -src.view.frame.size.width, y: 0)
    default: // Same as "up"
        srcTransform = CGAffineTransform(translationX: 0, y: -src.view.frame.size.height)
        dst.view.transform = CGAffineTransform(translationX: 0, y: src.view.frame.size.height)
    }

    UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseInOut, animations: {
        src.view.transform = srcTransform
        dst.view.transform = CGAffineTransform(translationX: 0, y: 0)
    },
                   completion: { (_) in
                    src.present(dst, animated: false, completion: nil)
    })
}

// --------------------------------------------------------------------------------

class SlideUpSegue: UIStoryboardSegue {
    override func perform() {
        addSlideSegueAnimation(direction: "up", storyboard: self)
    }
}

class SlideDownSegue: UIStoryboardSegue {
    override func perform() {
        addSlideSegueAnimation(direction: "down", storyboard: self)
    }
}

class SlideLeftSegue: UIStoryboardSegue {
    override func perform() {
        addSlideSegueAnimation(direction: "left", storyboard: self)
    }
}

class SlideRightSegue: UIStoryboardSegue {
    override func perform() {
        addSlideSegueAnimation(direction: "right", storyboard: self)
    }
}
