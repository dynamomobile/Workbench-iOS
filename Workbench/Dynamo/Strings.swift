import Foundation

struct Strings {

    static var lookup: [String: String] = stringsFromFile(name: "Strings")

    static func stringsFromFile(name: String) -> [String: String] {
        if let url = Bundle.main.url(forResource: name, withExtension: "json"),
            let data = try? Data(contentsOf: url),
            let json: [String: Any] = data.JSON(),
            let lookup = json as? [String: String] {
            return lookup
        }
        return [:]
    }

    static func loadStringsFromFile(name: String) {
        let list = stringsFromFile(name: name)
        if list != [:] {
            lookup = list
        }
    }

    static func lookup(string: String) -> String {
        if let string = Strings.lookup[string] {
            return string
        }
        return string
    }

}
