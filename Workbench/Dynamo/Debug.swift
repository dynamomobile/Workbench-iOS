import Foundation

struct Debug {

    static func info(_ output: String) {
        if AppConfig.debug {
            print(output)
        }
    }

}
