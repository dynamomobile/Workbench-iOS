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
        #if os(iOS)
            return try? JSONSerialization.data(withJSONObject: dictionary, options: [.prettyPrinted, .sortedKeys])
        #else
            return try? JSONSerialization.data(withJSONObject: dictionary, options: [.prettyPrinted])
        #endif
    }

    static func JSON(_ array: [Any]) -> Data? {
        #if os(iOS)
            return try? JSONSerialization.data(withJSONObject: array, options: [.prettyPrinted, .sortedKeys])
        #else
            return try? JSONSerialization.data(withJSONObject: array, options: [.prettyPrinted])
        #endif
    }

}
