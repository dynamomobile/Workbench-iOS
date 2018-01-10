import Foundation

private var associatedObjectsKey = "associatedObjectsKey"

extension NSObject {

    var associatedObjects: [String: Any]? {
        get {
            var dict = objc_getAssociatedObject(self, &associatedObjectsKey) as? [String: Any]
            if dict == nil {
                dict = [:]
                objc_setAssociatedObject(self, &associatedObjectsKey, dict, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
            return dict
        }
        set {
            if newValue == nil {
                let dict: [String: Any]? = [:]
                objc_setAssociatedObject(self, &associatedObjectsKey, dict, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            } else {
                objc_setAssociatedObject(self, &associatedObjectsKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    }

}
