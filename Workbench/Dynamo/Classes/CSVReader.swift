import Foundation

func csvReader(string: String) -> [[String: String]] {

    func csvReadLine(titles: [String], line: String) -> [String: String] {
        var result: [String: String] = [:]
        var rangeLeft: Range<String.Index>?
        var index = 0
        while let range = line.range(of: "([^,]*|\"([^\"]|\"\")*\")(,|$)",
                                     options: .regularExpression,
                                     range: rangeLeft,
                                     locale: nil) {
            var substr = line[range]
            if substr.hasSuffix(",") {
                substr = substr.dropLast()
                result[titles[index]] = String(substr)
            } else {
                result[titles[index]] = String(substr)
                return result
            }
            index += 1
            rangeLeft = Range(uncheckedBounds: (lower: range.upperBound, upper: line.endIndex))
        }
        return result
    }

    let lines = string.components(separatedBy: "\r\n")
    var list: [[String: String]] = []
    if lines.count > 1 {
        let titles = lines[0].components(separatedBy: ",")
        for i in 1..<lines.count {
            list.append(csvReadLine(titles: titles, line: lines[i]))
        }
    }

    return list
}
