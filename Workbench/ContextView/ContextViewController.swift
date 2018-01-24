import UIKit

class ContextViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var peopleInSpace: [[String: String]] = []

    @IBOutlet weak var tableView: UITableView!

    deinit {
        Debug.info("† deinit: \(String(describing: type(of: self)))")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.setFullContext([
            "title": "Context"
        ])

        if let url = URL(string: "http://api.open-notify.org/astros.json") {
            NetworkOperation(request: URLRequest(url: url)) { (data, response, _) in
                if let response = response as? HTTPURLResponse {
                    Debug.info("Response: \(response.statusCode)")
                    Debug.info("Data:     \(data?.count ?? 0)")
                    if let json: [String: Any] = data?.JSON(),
                        let people = json["people"] as? [[String: String]] {
                        self.peopleInSpace = people
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }
                }
            }.queue()
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "More Context" {
            segue.destination.view.setFullContext([
                "title": "More ...",
                "one": [ "two": [ "answer": "42" ] ],
                "more_label": "Don't Panic!"
            ])
        }
    }

    // MARK: - Table View DataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return peopleInSpace.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContextTableViewCell")
        cell?.setFullContext(peopleInSpace[indexPath.row])
        return cell!
    }

}
