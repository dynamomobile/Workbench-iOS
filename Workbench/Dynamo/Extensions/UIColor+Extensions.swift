import Foundation

private let lookup: [String: UIColor] = [
    "clear": .clear,
    "white": .white,
    "black": .black,
    "red": .red,
    "green": .green,
    "blue": .blue,
    "yellow": .yellow,
    "magenta": .magenta,
    "brown": .brown,
    "gray": .gray,
    "lightGray": .lightGray,
    "darkGray": .darkGray,
    "cyan": .cyan,
    "orange": .orange,
    "purple": .purple
]

extension UIColor {

    static func colorBy(name: String, defaultColor: UIColor? = .red) -> UIColor? {
        if let match = name.range(of: "^([0-9a-fA-F]{2}){3,4}$",
                                  options: .regularExpression,
                                  range: nil,
                                  locale: nil),
            var hex = Int(name, radix: 16) {
            var alpha: CGFloat = 1.0
            if name.distance(from: match.lowerBound, to: match.upperBound) == 8 {
                alpha = CGFloat(hex & 0xff)/255.0
                hex = hex >> 8
            }
            return UIColor(red: CGFloat((hex >> 16) & 0xff)/255.0,
                           green: CGFloat((hex >> 8) & 0xff)/255.0,
                           blue: CGFloat(hex & 0xff)/255.0,
                           alpha: alpha)
        }
        return lookup[name] ?? defaultColor
    }

}
