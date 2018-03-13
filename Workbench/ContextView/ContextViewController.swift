import UIKit

class ContextViewController: UIViewController, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!

    deinit {
        Debug.info("† deinit: \(String(describing: type(of: self)))")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.setFullContext([
            "title": Strings.lookup(string: "title_context")
        ])

        if let url = URL(string: "http://api.open-notify.org/astros.json") {
            NetworkOperation(request: URLRequest(url: url)) { (data, response, _) in
                if let response = response as? HTTPURLResponse {
                    Debug.info("Response: \(response.statusCode)")
                    Debug.info("Data:     \(data?.count ?? 0)")
                    if let json: [String: Any] = data?.JSON(),
                        let people = json["people"] as? [[String: String]] {
                        DispatchQueue.main.async {
                            self.tableView.setContextValue(people, forKey: "list")
                        }
                    }
                }
            }.queue()
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "More Context" {
            segue.destination.view.setFullContext([
                "title": Strings.lookup(string: "title_more"),
                "one": [ "two": [ "answer": "42" ] ],
                "more_label": "Don't Panic!",
                "intValue": 0xff350012,
                "floatValue": 398.23444554,
                "date": Date()
            ])
        }
    }

}
