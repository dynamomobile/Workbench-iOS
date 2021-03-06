import UIKit

class CSVViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    deinit {
        Debug.info("† deinit: \(String(describing: type(of: self)))")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // codestep-322AF646-9A49-4300-819D-31EFAF8A2CFC CSV Demo

        if let url = URL(string: "https://docs.google.com/spreadsheets/d/e/" +
            "2PACX-1vQsprRxOtY7tVC2GsVtsu-hYzbwMCrQJV6TuQUss4az-YjavOt2Dhu0DRcvGhFKA5HriHHBIlkNfeS1/" +
            "pub?gid=0&single=true&output=csv") {
            NetworkOperation(request: URLRequest(url: url)) { (data, response, _) in
                let httpResponse = response as? HTTPURLResponse
                if let code = httpResponse?.statusCode,
                    code == 200,
                    let data = data,
                    let string = String(data: data, encoding: .utf8) {
                    DispatchQueue.main.async {
                        self.view.setContextValue(csvReadLines(string: string), forKey: "csvData")
                    }
                }
            }.queue()
        }
    }

}
