//
//
//  Copyright © 2018 mkerekes. All rights reserved.
//


public protocol Module {}

public protocol ApplicationModules: class {
    func add<T>(_ module: T)
    func module<T>() -> T
    func modules<T>() -> [T]
}

public class ModuleTable: ApplicationModules {
    
    private init() {}
    private var _modules: [Module] = []
    public static let shared = ModuleTable()
    
    public func add<T>(_ module: T) {
        _modules.removeAll { (aModule) -> Bool in
            aModule is T
        }
        _modules.append(module as! Module)
    }
    
    public func module<T>() -> T {
        if let module = _modules.first(where: { (module) -> Bool in
            return module is T
        }) as? T {
            return module
        }
        fatalError("Module \(T.self) not registered")        
    }
    
    public func modules<T>() -> [T] {
        return _modules.compactMap({ module -> T? in
            return module as? T
        })
    }
}
