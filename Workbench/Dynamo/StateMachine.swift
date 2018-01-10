import Foundation

// ----------------------------------------------------------------------

class Event {

    var id: String
    var userdata: [String: Any]

    deinit {
        Debug.info("† deinit: \(String(describing: type(of: self)))")
    }

    init(id: String, userdata: [String: Any] = [:]) {
        self.id = id
        self.userdata = userdata
    }

}

// ----------------------------------------------------------------------

class EventDispatcher {

    typealias EventCallback = ((Event) -> Void)

    var eventHandlerID = 1
    var eventHandlers: [String: [Int: EventCallback]] = [:]
    var reverseIDLookup: [Int: String] = [:]
    var stateMachine: StateMachine?

    deinit {
        Debug.info("† deinit: \(String(describing: type(of: self)))")
    }

    func dispatch(event: Event) {
        Debug.info("Begin dispatch event: \(event.id)")
        eventHandlers[event.id]?.forEach { (_, eventHandler) in
            eventHandler(event)
        }
        Debug.info("End dispatch event: \(event.id)")
        stateMachine?.handle(event: event)
    }

    func dispatchOnMain(event: Event) {
        DispatchQueue.main.async {
            self.dispatch(event: event)
        }
    }

    func removeHandler(id: Int) {
        if let event = reverseIDLookup[id] {
            eventHandlers[event]?.removeValue(forKey: id)
            reverseIDLookup.removeValue(forKey: id)
        }
    }

    @discardableResult func on(event: String, do callback: @escaping EventCallback) -> Int {
        let id = eventHandlerID
        eventHandlerID += 1
        if eventHandlers[event] == nil {
            eventHandlers[event] = [id: callback]
        } else {
            eventHandlers[event]?[id] = callback
        }
        reverseIDLookup[id] = event
        return id
    }

}

// ----------------------------------------------------------------------

class StateMachine {
    var name: String?
    var current: String
    var states: [String: [String: String]] = [:]
    var stateHandlerID = 1
    var stateHandlers: [String: [Int: EventDispatcher.EventCallback]] = [:]
    var reverseIDLookup: [Int: String] = [:]

    deinit {
        Debug.info("† deinit: \(String(describing: type(of: self)))")
    }

    init(start: String) {
        current = start
    }

    func at(state: String, on event: String, goto next: String) {
        if states[state] == nil {
            states[state] = [event: next]
        } else {
            states[state]?[event] = next
        }
    }

    @discardableResult func on(state: String, do callback: @escaping EventDispatcher.EventCallback) -> Int {
        let id = stateHandlerID
        stateHandlerID += 1
        if stateHandlers[state] == nil {
            stateHandlers[state] = [id: callback]
        } else {
            stateHandlers[state]?[id] = callback
        }
        reverseIDLookup[id] = state
        return id
    }

    func removeHandler(id: Int) {
        if let event = reverseIDLookup[id] {
            stateHandlers[event]?.removeValue(forKey: id)
            reverseIDLookup.removeValue(forKey: id)
        }
    }

    func handle(event: Event) {
        if let next = states[current]?[event.id] {
            if let name = name {
                Debug.info("State machine: \(name)")
            }
            Debug.info("Begin enter state: \(next)")
            current = next
            stateHandlers[current]?.forEach { (_, stateHandler) in
                stateHandler(event)
            }
            if let name = name {
                Debug.info("State machine: \(name)")
            }
            Debug.info("End enter state: \(next)")
        }
    }

    func dot() -> String {
        let eol = "\n"
        var dot = "// Dot file description of state machine \(name ?? "")" + eol
        dot += "digraph {" + eol
        dot += "  graph [rankdir=LR]" + eol
        var indexes: [String: Int] = [:]
        states.keys.enumerated().forEach { (i, state) in
            dot += "  \(i) [label=\"\(state)\"]" + eol
            indexes[state] = i
        }
        states.keys.forEach { (state) in
            states[state]?.forEach { (event, nextState) in
                dot += "  \(indexes[state] ?? 0) -> \(indexes[nextState] ?? 0) [label=\"\(event)\"]" + eol
            }
        }
        dot += "}" + eol
        dot += "// End."
        return dot
    }

    func outputDot() {
        print("dot -Tpdf -o graph.pdf <<EOF")
        print(dot())
        print("EOF")
        print("open graph.pdf")
    }

}
