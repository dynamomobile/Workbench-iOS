import UIKit

class AppSchemeData {

    static var shared: AppSchemeData = {
        return AppSchemeData()
    }()

    private var data: [String: String] = [:]

    func update(url: URL) {
        var collect: [String: String] = [:]

        if url.host == "set" {
            url.query?.components(separatedBy: "&").forEach({ (string) in
                let parts = string.components(separatedBy: "=")
                if parts.count == 2,
                    let first = parts.first,
                    let last = parts.last {
                    collect[first] = last.replacingOccurrences(of: "+", with: " ").removingPercentEncoding
                }
            })
        }

        if collect.count > 0 {
            data = collect
        } else {
            data = [:]
        }
    }

    func lookupBoolBy(name: String) -> Bool? {
        if let val = data[name] {
            switch val {
            case "1", "true", "YES":
                return true
            case "0", "false", "NO":
                return false
            default:
                return nil
            }
        }
        return nil
    }

    func lookupIntBy(name: String) -> Int? {
        if let val = data[name] {
            return Int(val)
        }
        return nil
    }

    func lookupFloatBy(name: String) -> Float? {
        if let val = data[name] {
            return Float(val)
        }
        return nil
    }

    func lookupStringBy(name: String) -> String? {
        return data[name]
    }

    func lookupColorBy(name: String) -> UIColor? {
        if let colorName = data[name] {
            return UIColor.colorBy(name: colorName, defaultColor: nil)
        }
        return nil
    }

}
