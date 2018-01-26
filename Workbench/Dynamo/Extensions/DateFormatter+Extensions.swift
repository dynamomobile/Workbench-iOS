import Foundation

private var cachedFormatters: [String: DateFormatter] = [:]

extension DateFormatter {

    static func reusableBy(format: String) -> DateFormatter {
        var formatter = cachedFormatters[format]
        if formatter == nil {
            formatter = DateFormatter()
            formatter?.dateFormat = format
            cachedFormatters[format] = formatter!
        }
        return formatter!
    }

}
