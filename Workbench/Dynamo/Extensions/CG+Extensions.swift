import UIKit

extension CGRect {

    func squareFit() -> CGRect {
        var rect = self
        if rect.size.width > rect.size.height {
            rect.origin.x += (rect.size.width-rect.size.height)/2.0
            rect.size.width = rect.size.height
        } else if rect.size.height > rect.size.width {
            rect.origin.y += (rect.size.height-rect.size.width)/2.0
            rect.size.height = rect.size.width
        }
        return rect
    }

    func rectPath() -> UIBezierPath {
        return UIBezierPath(rect: self)
    }

    func rectPath(cornerRadius: CGFloat) -> UIBezierPath {
        return UIBezierPath(roundedRect: self, cornerRadius: cornerRadius)
    }

    func ovalPath() -> UIBezierPath {
        return UIBezierPath(ovalIn: self)
    }

    func circlePath() -> UIBezierPath {
        return UIBezierPath(ovalIn: self.squareFit())
    }

}

// ----------------------------------------------------------------------

extension CGPoint {

    static func + (left: CGPoint, right: CGPoint) -> CGPoint {
        return CGPoint(x: left.x+right.x, y: left.y+right.y)
    }

    static func - (left: CGPoint, right: CGPoint) -> CGPoint {
        return CGPoint(x: left.x-right.x, y: left.y-right.y)
    }

    static func * (left: CGPoint, right: CGFloat) -> CGPoint {
        return CGPoint(x: left.x*right, y: left.y*right)
    }

    static func / (left: CGPoint, right: CGFloat) -> CGPoint {
        return CGPoint(x: left.x/right, y: left.y/right)
    }

    // swiftlint:disable shorthand_operator
    static func += (left: inout CGPoint, right: CGPoint) {
        left = left + right
    }

    static func -= (left: inout CGPoint, right: CGPoint) {
        left = left - right
    }
    // swiftlint:enable shorthand_operator

    func ceil() -> CGPoint {
        return CGPoint(x: Darwin.ceil(x), y: Darwin.ceil(y))
    }
}

// ----------------------------------------------------------------------

extension CGSize {
    func ceil() -> CGSize {
        return CGSize(width: Darwin.ceil(width), height: Darwin.ceil(height))
    }
}
