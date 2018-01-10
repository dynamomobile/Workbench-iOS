import Foundation

extension DispatchQueue {

    static func onMain(after milliseconds: Int, block: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(milliseconds), execute: block)
    }

}
