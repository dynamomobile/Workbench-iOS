import UIKit
import WebKit

// TODO: Add some UI to show state machine usage

class StateMachineViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!

    var eventDispatcher = EventDispatcher()

    deinit {
        Debug.info("† deinit: \(String(describing: type(of: self)))")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupStateMachineAndEventHandlers()

        view.setContextValue("Started", forKey: "state")

        // Event handlers can be removed, here add an event handler, which we will remove later**
        let last_id = eventDispatcher.on(event: "last") { (event) in
            Debug.info("!! Dummy event handler called \(event.id)") // This should never be outputed
        }

        eventDispatcher.dispatchOnMain(event: Event(id: "first"))

        // Remove the event handler we created earlier**
        eventDispatcher.removeHandler(id: last_id)
    }

    override func viewDidAppear(_ animated: Bool) {
        presentCallouts()
    }

    func setupStateMachineAndEventHandlers() {
        // Setup a small state machine
        eventDispatcher.stateMachine = StateMachine(start: "start")
        eventDispatcher.stateMachine?.at(state: "start", on: "A", goto: "running")
        eventDispatcher.stateMachine?.at(state: "start", on: "C", goto: "idle")
        eventDispatcher.stateMachine?.at(state: "running", on: "B", goto: "start")
        eventDispatcher.stateMachine?.at(state: "running", on: "C", goto: "idle")
        eventDispatcher.stateMachine?.at(state: "idle", on: "A", goto: "running")
        eventDispatcher.stateMachine?.at(state: "idle", on: "B", goto: "start")

        // Monitor state changes to set the state label
        eventDispatcher.stateMachine?.on(state: nil) { [weak self] (event) in
            if let state = self?.eventDispatcher.stateMachine?.current {
                print("####### \(event.userdata)")
                self?.view.setContextValue(state, forKey: "state")
            }
        }

        // Output a dot file, to view the state machine
        eventDispatcher.stateMachine?.outputDot()

        // Add state machine callbacks
        eventDispatcher.stateMachine?.on(state: "start") { (event) in
            print("** Entered start with \(event.id)")
        }
        eventDispatcher.stateMachine?.on(state: "running") { (event) in
            print("** Entered running with \(event.id)")
        }

        // Add some event handlers [seperate from the statemachine]
        // eventDispatcher.on(event: nil) { (event) in
        //     print("## \(event.id)")
        // }
        eventDispatcher.on(event: "A") { (event) in
            print(">> \(event.id)")
        }
        eventDispatcher.on(event: "B") { (event) in
            print(">> \(event.id)")
        }
        eventDispatcher.on(event: "C") { (event) in
            print(">> \(event.id)")
            CalloutView.resetCallouts()
        }

        // Convert dot description to png
        var request = URLRequest(url: URL(string: "https://rpi.memention.net/cgi-bin/dot-png.cgi")!)
        request.httpMethod = "POST"
        request.httpBody = eventDispatcher.stateMachine?.dot().data(using: .utf8)

        NetworkOperation(request: request) { (data, response, _) in
            if let response = response as? HTTPURLResponse {
                Debug.info("Response: \(response.statusCode)")
                Debug.info("Data:     \(data?.count ?? 0)")
                if let data = data,
                    let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.imageView.image = image
                    }
                }
            }
        }.queue()

    }

    @IBAction func buttonPressed(_ sender: UIButton!) {
        if let event = sender.titleLabel?.text {
            eventDispatcher.dispatchOnMain(event: Event(id: event, userdata: ["date": Date()]))
        }
    }

}
