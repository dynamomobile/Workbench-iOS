import UIKit

class DownloadViewController: UIViewController {

    @IBOutlet var animatedCheckmarkView1: AnimatedCheckmarkView!
    @IBOutlet var animatedCheckmarkView2: AnimatedCheckmarkView!
    @IBOutlet var animatedCheckmarkView3: AnimatedCheckmarkView!
    @IBOutlet var animatedCheckmarkView4: AnimatedCheckmarkView!
    @IBOutlet var animatedCheckmarkView5: AnimatedCheckmarkView!

    @IBOutlet var label1: UILabel!
    @IBOutlet var label2: UILabel!
    @IBOutlet var label3: UILabel!
    @IBOutlet var label4: UILabel!
    @IBOutlet var label5: UILabel!

    deinit {
        NetworkOperation.cancelAll()
        Debug.info("† deinit: \(String(describing: type(of: self)))")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        resetCheckmarksAndLabels()
    }

    func resetCheckmarksAndLabels() {
        label1.text = ""
        label2.text = ""
        label3.text = ""
        label4.text = ""
        label5.text = ""

        animatedCheckmarkView1.isChecked = false
        animatedCheckmarkView2.isChecked = false
        animatedCheckmarkView3.isChecked = false
        animatedCheckmarkView4.isChecked = false
        animatedCheckmarkView5.isChecked = false
    }

    func startDownloads() {

        // Local function to simplify network calls
        func callNetwork(url: URL, checkmark: AnimatedCheckmarkView, label: UILabel) {
            NetworkOperation(request: URLRequest(url: url)) { (data, response, _) in
                if let response = response as? HTTPURLResponse {
                    Debug.info("Response: \(response.statusCode)")
                    Debug.info("Data:     \(data?.count ?? 0)")
                    DispatchQueue.main.async {
                        checkmark.isChecked = true
                        label.text = "\(data?.count ?? -1): " + (response.url?.absoluteString ?? "")
                    }
                }
            }.queue()
        }

        let list = [
            ("https://youtube.com", animatedCheckmarkView1!, label1!),
            ("https://expressen.se", animatedCheckmarkView2!, label2!),
            ("https://cnn.com", animatedCheckmarkView3!, label3!),
            ("https://google.com", animatedCheckmarkView4!, label4!),
            ("https://apple.com", animatedCheckmarkView5!, label5!)
        ]

        list.forEach { (url, checkmark, label) in
            callNetwork(url: URL(string: url)!, checkmark: checkmark, label: label)
        }
    }

    @IBAction func downloadPressed(_ sender: UIButton) {
        NetworkOperation.cancelAll()
        resetCheckmarksAndLabels()
        startDownloads()
    }

}
