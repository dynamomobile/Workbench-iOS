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
        return lookup[name] ?? defaultColor
    }

}
