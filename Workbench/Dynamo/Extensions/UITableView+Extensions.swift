import UIKit

extension UITableView {

    @IBInspectable dynamic var cells: String {
        get {
            // Ever reading it? then add a stored property with associatedObject I guess
            return ""
        }
        set {
            let cells = newValue.components(separatedBy: ",").map { (item) -> String in
                return item.trimmingCharacters(in: .whitespaces)
            }
            for item in cells {
                register(UINib.init(nibName: item, bundle: nil), forCellReuseIdentifier: item)
            }
        }
    }

}
