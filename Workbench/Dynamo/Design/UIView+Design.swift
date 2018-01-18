import UIKit

// These are the UIView extensions that work as recipients for 'User Defined Runtime Attributes'
// Here is just a small sample of UIView subclasses and usages. Be creative and add you own! :)
extension UIView {

    //      _______  _      __        _
    //     /  _/ _ )(_) ___/ /__ ___ (_)__ ____
    //    _/ // _  |   / _  / -_|_-</ / _ `/ _ \
    //   /___/____(_)  \_,_/\__/___/_/\_, /_//_/
    //                               /___/

    static func languageStyledLookup(string: String) -> String {
        if string.prefix(1) == "^" {
            let str = Strings.lookup(string: String(string[string.index(after: string.startIndex)...]))
            return str.uppercased()
        }
        return Strings.lookup(string: string)
    }

    @IBInspectable dynamic var design: String {
        get {
            // Ever reading it? then add a stored property with associatedObject I guess
            return ""
        }
        set {

            //     __  _________       __  __
            //    / / / /  _/ _ )__ __/ /_/ /____  ___
            //   / /_/ // // _  / // / __/ __/ _ \/ _ \
            //   \____/___/____/\_,_/\__/\__/\___/_//_/
            //
            if self.isKind(of: UIButton.self), let button = self as? UIButton {
                if newValue.contains(":") {
                    let components = newValue.components(separatedBy: ":")
                    button.backgroundColor = UIColor.colorBy(name: components[0])
                    button.setTitleColor(UIColor.colorBy(name: components[1]), for: UIControlState.normal)
                } else {
                    button.backgroundColor = UIColor.colorBy(name: newValue)
                }

                //     __  ____________        __  _____     __   __
                //    / / / /  _/_  __/____ __/ /_/ __(_)__ / /__/ /
                //   / /_/ // /  / / / -_) \ / __/ _// / -_) / _  /
                //   \____/___/ /_/  \__/_\_\\__/_/ /_/\__/_/\_,_/
                //
            } else if self.isKind(of: UITextField.self), let textField = self as? UITextField {
                if newValue.contains(":") {
                    let components = newValue.components(separatedBy: ":")
                    textField.backgroundColor = UIColor.colorBy(name: components[0])
                    textField.textColor = UIColor.colorBy(name: components[1])
                } else {
                    textField.backgroundColor = UIColor.colorBy(name: newValue)
                }

                //     __  ________        __       __
                //    / / / /  _/ /  ___ _/ /  ___ / /
                //   / /_/ // // /__/ _ `/ _ \/ -_) /
                //   \____/___/____/\_,_/_.__/\__/_/
                //
            } else if self.isKind(of: UILabel.self), let label = self as? UILabel {
                label.textColor = UIColor.colorBy(name: newValue)

                //     __  __________       _ __      __
                //    / / / /  _/ __/    __(_) /_____/ /
                //   / /_/ // /_\ \| |/|/ / / __/ __/ _ \
                //   \____/___/___/|__,__/_/\__/\__/_//_/
                //
            } else if self.isKind(of: UISwitch.self), let sw = self as? UISwitch {
                sw.onTintColor = UIColor.colorBy(name: newValue)

                //     __  __________                   _   ___
                //    / / / /  _/  _/_ _  ___ ____ ____| | / (_)__ _    __
                //   / /_/ // /_/ //  ' \/ _ `/ _ `/ -_) |/ / / -_) |/|/ /
                //   \____/___/___/_/_/_/\_,_/\_, /\__/|___/_/\__/|__,__/
                //                           /___/
            } else if self.isKind(of: UIImageView.self), let imageView = self as? UIImageView {
                if newValue.contains("circle") {
                    imageView.layer.cornerRadius = min(imageView.frame.width, imageView.frame.height) / 2.0
                }

                //     __  __________                 __   ___
                //    / / / /  _/ __/__ ___ _________/ /  / _ )___ _____
                //   / /_/ // /_\ \/ -_) _ `/ __/ __/ _ \/ _  / _ `/ __/
                //   \____/___/___/\__/\_,_/_/  \__/_//_/____/\_,_/_/
                //
            } else if self.isKind(of: UISearchBar.self), let searchBar = self as? UISearchBar {
                if newValue.contains(":") {
                    let textField = searchBar.value(forKey: "searchField") as? UITextField
                    let components = newValue.components(separatedBy: ":")
                    searchBar.barTintColor = UIColor.colorBy(name: components[1])
                    textField?.backgroundColor = UIColor.colorBy(name: components[0])
                    if components.count > 2 {
                        textField?.textColor = UIColor.colorBy(name: components[2])
                    }
                    if components.count > 3 {
                        searchBar.tintColor = UIColor.colorBy(name: components[3])
                    }
                } else {
                }

                // TODO: Add more cases for other subclasses of UIView

                // Defaults to setting background color
            } else {
                backgroundColor = UIColor.colorBy(name: newValue)
            }
        }
    }

    func reapplyDesignTitle() {
        for view in subviews {
            view.reapplyDesignTitle()
        }
        if designTitle != "" {
            designTitle = String(designTitle)
        }
    }

    //      _______  _      __        _         _______ __  __
    //     /  _/ _ )(_) ___/ /__ ___ (_)__ ____/_  __(_) /_/ /__
    //    _/ // _  |   / _  / -_|_-</ / _ `/ _ \/ / / / __/ / -_)
    //   /___/____(_)  \_,_/\__/___/_/\_, /_//_/_/ /_/\__/_/\__/
    //                               /___/
    @IBInspectable dynamic var designTitle: String {
        get {
            // Ever reading it? then add a stored property with associatedObject I guess
            return ""
        }
        set {

            //     __  _________       __  __
            //    / / / /  _/ _ )__ __/ /_/ /____  ___
            //   / /_/ // // _  / // / __/ __/ _ \/ _ \
            //   \____/___/____/\_,_/\__/\__/\___/_//_/
            //
            if self.isKind(of: UIButton.self), let button = self as? UIButton {
                // TODO: Maybe use the title itsel?
                button.setTitle( UIView.languageStyledLookup(string: newValue), for: .normal)
                button.setTitle( UIView.languageStyledLookup(string: newValue), for: .highlighted)

                //     __  ________        __       __
                //    / / / /  _/ /  ___ _/ /  ___ / /
                //   / /_/ // // /__/ _ `/ _ \/ -_) /
                //   \____/___/____/\_,_/_.__/\__/_/
                //
            } else if self.isKind(of: UILabel.self), let label = self as? UILabel {
                // TODO: Maybe use the title itsel?
                label.text = UIView.languageStyledLookup(string: newValue)

                //     __  ____________        __ _   ___
                //    / / / /  _/_  __/____ __/ /| | / (_)__ _    __
                //   / /_/ // /  / / / -_) \ / __/ |/ / / -_) |/|/ /
                //   \____/___/ /_/  \__/_\_\\__/|___/_/\__/|__,__/
                //
            } else if self.isKind(of: UITextView.self), let textView = self as? UITextView {
                // TODO: Maybe use the text itsel?
                textView.text = UIView.languageStyledLookup(string: newValue)

            } else {

                // TODO: Add more cases for other subclasses of UIView, ie UILabel

            }
        }
    }

    //      _______  _      __        _           ___  __             __        __   __
    //     /  _/ _ )(_) ___/ /__ ___ (_)__ ____  / _ \/ /__ ________ / /  ___  / /__/ /__ ____
    //    _/ // _  |   / _  / -_|_-</ / _ `/ _ \/ ___/ / _ `/ __/ -_) _ \/ _ \/ / _  / -_) __/
    //   /___/____(_)  \_,_/\__/___/_/\_, /_//_/_/  /_/\_,_/\__/\__/_//_/\___/_/\_,_/\__/_/
    //                               /___/
    @IBInspectable dynamic var designPlaceholder: String {
        get {
            // Ever reading it? then add a stored property with associatedObject I guess
            return ""
        }
        set {

            //     __  __________                 __   ___
            //    / / / /  _/ __/__ ___ _________/ /  / _ )___ _____
            //   / /_/ // /_\ \/ -_) _ `/ __/ __/ _ \/ _  / _ `/ __/
            //   \____/___/___/\__/\_,_/_/  \__/_//_/____/\_,_/_/
            //
            if self.isKind(of: UISearchBar.self), let searchBar = self as? UISearchBar {

                // TODO: Maybe use the placeholder itself?
                searchBar.placeholder = UIView.languageStyledLookup(string: newValue)

            } else {

                // TODO: Add more cases for other subclasses of UIView

            }
        }
    }

    @IBInspectable var borderColor: String {
        get {
            return ""
        }
        set {
            self.layer.borderColor = UIColor.colorBy(name: newValue)?.cgColor
        }
    }

    @IBInspectable var borderWidth: String {
        get {
            return ""
        }
        set {
            self.layer.borderWidth = CGFloat(Float(newValue) ?? Float.constantBy(name: newValue))
        }
    }

    @IBInspectable var roundedCornerRadius: String {
        get {
            return ""
        }
        set {
            self.layer.cornerRadius = CGFloat(Float(newValue) ?? Float.constantBy(name: newValue))
        }
    }

}
