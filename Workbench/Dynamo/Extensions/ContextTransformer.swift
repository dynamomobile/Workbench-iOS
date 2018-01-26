import Foundation

protocol ContextTransformer {
    func toString(extra: String?) -> String
}

extension String: ContextTransformer {
    func toString(extra: String?) -> String {
        return self
    }
}

extension NSString: ContextTransformer {
    func toString(extra: String?) -> String {
        return String(self)
    }
}

extension Date: ContextTransformer {
    func toString(extra: String?) -> String {
        if let extra = extra {
            return DateFormatter.reusableBy(format: extra).string(from: self)
        }
        return description
    }
}

extension NSDate: ContextTransformer {
    func toString(extra: String?) -> String {
        if let extra = extra {
            return DateFormatter.reusableBy(format: extra).string(from: self as Date)
        }
        return description
    }
}
