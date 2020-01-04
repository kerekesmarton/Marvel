//
//  Domain
//
//  Copyright © 2018 mkerekes. All rights reserved.
//

import Foundation
import Additions

public protocol FeatureFlagLoading {
    func load(completion: @escaping (FeatureFlags?) -> Void)
    var results: FeatureFlags? { get set }
}

public class FeatureFlagLoader: AsyncOperaiton, FeatureFlagLoading {
    public typealias T = FeatureFlags
    
    let service: GenericDataService
    public init(service: GenericDataService) {
        self.service = service
        super.init()
    }
    
    public func load(completion: @escaping (FeatureFlags?) -> Void) {
        service.getData { (result: Result<FeatureFlags,ServiceError>) in
            let flag = try? result.get()
            completion(flag)
        }
    }
    
    public var results: FeatureFlags?
    
    public override func main() {
        super.main()
        load { (flags) in
            self.results = flags
            self.state = .finished
        }
    }
}
