//
//  Additions
//  Copyright © 2018 mkerekes. All rights reserved.
//

import Foundation

public protocol Dispatching {
    func dispatchMain(block: @escaping () -> Void)
    func dispatchMain(after seconds: Double, block: @escaping () -> Void)
    func dispatch(queue: DispatchQueue, block: @escaping () -> Void)
    func dispatch(after seconds: Double, queue: DispatchQueue, block: @escaping () -> Void)
}

public struct Dispatcher: Dispatching {
    public func dispatchMain(block: @escaping () -> Void) {
        dispatchMain(after: 0, block: block)
    }
    
    public init() {}
    public func dispatchMain(after seconds: Double = 0.0, block: @escaping () -> Void) {
        dispatch(after: seconds, queue: DispatchQueue.main, block: block)
    }
    
    public func dispatch(queue: DispatchQueue, block: @escaping () -> Void) {
        queue.async {
            block()
        }
    }
    
    public func dispatch(after seconds: Double, queue: DispatchQueue, block: @escaping () -> Void) {
        queue.asyncAfter(deadline: .now()+seconds, execute: {
            block()
        })
    }
}

public struct MockDispatcher: Dispatching {
    public init() {}
    
    public func dispatchMain(block: @escaping () -> Void) {
        block()
    }
    
    public func dispatchMain(after seconds: Double, block: @escaping () -> Void) {
        block()
    }
    
    public func dispatch(queue: DispatchQueue, block: @escaping () -> Void) {
        block()
    }
    
    public func dispatch(after seconds: Double, queue: DispatchQueue, block: @escaping () -> Void) {
        block()
    }
}
