import UIKit

class NetworkOperation: Operation {

    private static let cacheOffSession: URLSession = {
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .reloadIgnoringLocalCacheData
        config.urlCache = nil
        return URLSession(configuration: config)
    }()

    private static let defaultNetworkOperationQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = AppConfig.maxConcurrentNetworkOperationCount
        return queue
    }()

    var request: URLRequest?
    var completionHandler: ((Data?, URLResponse?, Error?) -> Void)?
    var _isExecuting: Bool = false
    var _isFinished: Bool = false

    override var isAsynchronous: Bool { return true }
    override var isExecuting: Bool { return _isExecuting }
    override var isFinished: Bool { return _isFinished }

    deinit {
        Debug.info("† deinit: \(String(describing: type(of: self)))")
    }

    init(request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        self.request = request
        self.completionHandler = completionHandler
    }

    func queue(_ queue: OperationQueue? = nil) {
        if let queue = queue {
            queue.addOperation(self)
        } else {
            NetworkOperation.defaultNetworkOperationQueue.addOperation(self)
        }
    }

    func completeOperation() {
        willChangeValue(forKey: "isFinished")
        willChangeValue(forKey: "isExecuting")
        _isExecuting = false
        _isFinished = true
        didChangeValue(forKey: "isExecuting")
        didChangeValue(forKey: "isFinished")
    }

    override func start() {
        Debug.info("Begin \(#function)")

        if isCancelled {
            willChangeValue(forKey: "isFinished")
            _isFinished = true
            didChangeValue(forKey: "isFinished")
            return
        }

        if let request = request {
            willChangeValue(forKey: "isExecuting")
            _isExecuting = true
            NetworkOperation.cacheOffSession.dataTask(with: request) { (data, response, error) in
                self.completionHandler?(data, response, error)
                self.completeOperation()
            }.resume()
            didChangeValue(forKey: "isExecuting")
        }

        Debug.info("End \(#function)")
    }

    static func cancelAll() {
        NetworkOperation.defaultNetworkOperationQueue.cancelAllOperations()
    }

}
