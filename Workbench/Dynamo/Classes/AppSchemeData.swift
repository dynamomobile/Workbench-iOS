import UIKit

class AppSchemeData {

    private class AppSchemeDataParasite: NSObject {

        static let updateNotification = Notification.Name("AppSchemeDataUpdateNotification")
        var observer: NSObjectProtocol?

        deinit {
            Debug.info("† deinit: \(String(describing: type(of: self)))")
            NotificationCenter.default.removeObserver(observer!)
        }

        init(_ updateBlock: @escaping () -> Void) {
            super.init()
            observer = NotificationCenter.default.addObserver(forName: AppSchemeDataParasite.updateNotification,
                                                              object: nil,
                                                              queue: nil) { (_) in updateBlock() }
        }

    }

    static var shared: AppSchemeData = {
        return AppSchemeData()
    }()

    private var data: [String: String] = [:]

    func register(observer: NSObject, updateBlock: @escaping () -> Void) {
        observer.associatedObjects?["AppSchemeDataParasite"] = AppSchemeDataParasite(updateBlock)
    }

    func update(url: URL) {
        var collect: [String: String] = [:]

        // codestep-45C9BE9F-043F-4D9B-B9A3-0B2C4073B72F App Scheme Config
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

        NotificationCenter.default.post(name: AppSchemeDataParasite.updateNotification, object: nil)
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
