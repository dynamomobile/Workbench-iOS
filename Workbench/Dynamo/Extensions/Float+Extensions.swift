import Foundation

extension Float {

    static let goldenRatio = 1.6180339887498948482

    static var lookup: [String: Float] = loadFloatsJSON()

    static func loadFloatsJSON() -> [String: Float] {
        if let url = Bundle.main.url(forResource: "Floats", withExtension: "json"),
            let data = try? Data(contentsOf: url),
            let json: [String: Any] = data.JSON(),
            let lookup = json as? [String: Float] {
            return lookup
        }
        return [:]
    }

    static func constantBy(name: String) -> Float {
        return lookup[name] ?? 0.0
    }

    static func constantBy(name: String) -> CGFloat {
        return CGFloat(constantBy(name: name) as Float)
    }

}
