import Foundation

struct Strings {

    static var lookup: [String: String] = loadStringsJSON()

    static func loadStringsJSON() -> [String: String] {
        if let url = Bundle.main.url(forResource: "Strings", withExtension: "json"),
            let data = try? Data(contentsOf: url),
            let json: [String: Any] = data.JSON(),
            let lookup = json as? [String: String] {
            return lookup
        }
        return [:]
    }

    static func lookup(string: String) -> String {
        if let string = Strings.lookup[string] {
            return string
        }
        return string
    }

}
