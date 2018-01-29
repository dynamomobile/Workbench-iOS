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

extension NSNumber: ContextTransformer {
    func toString(extra: String?) -> String {
        if let extra = extra {
            if extra.range(of: "%[0-9]*[.]{0,1}[0-9]*[fF]",
                           options: .regularExpression,
                           range: nil,
                           locale: nil) != nil {
                return String(format: extra, self.floatValue)
            }
            return String(format: extra, self.intValue)
        }
        return stringValue
    }
}
