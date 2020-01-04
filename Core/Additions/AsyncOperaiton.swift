//
//  Additions
//
//  Copyright © 2018 mkerekes. All rights reserved.
//

import UIKit

open class AsyncOperaiton: Operation {
    override open var isAsynchronous: Bool { return true }
    override open var isExecuting: Bool { return state == .executing }
    override open var isFinished: Bool { return state == .finished }
    
    public var state = State.ready {
        willSet {
            willChangeValue(forKey: state.keyPath)
            willChangeValue(forKey: newValue.keyPath)
        }
        didSet {
            didChangeValue(forKey: state.keyPath)
            didChangeValue(forKey: oldValue.keyPath)
        }
    }
    
    public enum State: String {
        case ready = "Ready"
        case executing = "Executing"
        case finished = "Finished"
        fileprivate var keyPath: String { return "is" + self.rawValue }
    }
    
    override open func start() {
        if self.isCancelled {
            state = .finished
        } else {
            state = .ready
            main()
        }
    }
    
    override open func main() {
        if self.isCancelled {
            state = .finished
        } else {
            state = .executing
        }
    }
}
