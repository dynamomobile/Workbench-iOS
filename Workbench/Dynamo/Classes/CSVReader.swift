import Foundation

private func csvReadLine(_ line: String) -> [String] {
    var result: [String] = []
    var rangeLeft: Range<String.Index>?
    var done = false
    while let range = line.range(of: "(([^,\"]*)|(\"([^\"]|\"\")*\"))(,|$)",
                                 options: .regularExpression,
                                 range: rangeLeft,
                                 locale: nil) {
        var substr = line[range]
        if substr.hasSuffix(",") {
            substr = substr.dropLast()
        } else {
            done = true
        }
        if substr.hasPrefix("\"") && substr.hasSuffix("\"") {
            substr = substr.dropFirst().dropLast()
        }
        result.append(String(substr).replacingOccurrences(of: "\"\"", with: "\""))
        if done {
            return result
        }
        rangeLeft = Range(uncheckedBounds: (lower: range.upperBound, upper: line.endIndex))
    }
    return result
}

func csvReadLines(string: String) -> [[String: String]] {

    let lines = string.components(separatedBy: "\r\n")
    var list: [[String: String]] = []
    if lines.count > 1 {
        let titles = csvReadLine(lines[0])
        for i in 1..<lines.count {
            var item: [String: String] = [:]
            let values = csvReadLine(lines[i])
            for i in 0..<min(titles.count, values.count) {
                item[titles[i]] = values[i]
            }
            list.append(item)
        }
    }

    return list
}

func csvReadLookup(string: String, keyName: String, valueName: String) -> [String: String] {

    let lines = string.components(separatedBy: "\r\n")
    var dictionary: [String: String] = [:]
    if lines.count > 1 {
        let titles = csvReadLine(lines[0])
        if let keyIndex = titles.index(of: keyName),
            let valueIndex = titles.index(of: valueName) {
            for i in 1..<lines.count {
                let values = csvReadLine(lines[i])
                dictionary[values[keyIndex]] = values[valueIndex]
            }

        }
    }

    return dictionary
}
