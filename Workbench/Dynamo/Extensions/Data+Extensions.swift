import Foundation

extension Data {

    func JSON() -> [String: Any]? {
        return (try? JSONSerialization.jsonObject(with: self,
                                                  options: [.allowFragments, .mutableContainers, .mutableLeaves]))
            as? [String: Any]
    }

    func JSON() -> [Any]? {
        return (try? JSONSerialization.jsonObject(with: self,
                                                  options: [.allowFragments, .mutableContainers, .mutableLeaves]))
            as? [Any]
    }

    static func JSON(_ dictionary: [String: Any]) -> Data? {
        return try? JSONSerialization.data(withJSONObject: dictionary, options: [.prettyPrinted, .sortedKeys])
    }

    static func JSON(_ array: [Any]) -> Data? {
        return try? JSONSerialization.data(withJSONObject: array, options: [.prettyPrinted, .sortedKeys])
    }

}
