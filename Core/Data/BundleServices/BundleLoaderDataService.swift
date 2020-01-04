//
//  Data
//
//  Copyright © 2018 mkerekes. All rights reserved.
//

import Foundation
import Domain
import Additions

public protocol PathCalculator {
    var path: String? { get }
}

class BundleLoaderDataService<Parser: DataParsing>: GenericDataService {
    let file: PathCalculator
    let parser: Parser
    
    public init(file: PathCalculator, parser: Parser) {
        self.file = file
        self.parser = parser
    }
    
    func data(from file: String) -> NSData? {
        return NSData(contentsOfFile: file)
    }
    
    public func getData<T>(fetchResult: @escaping (T?, ServiceError?) -> Void) {
        guard let path = file.path else {
            fetchResult(nil, ServiceError.parsing("File not found"))
            return
        }
        
        guard let data = data(from: path) as Data? else {
            fetchResult(nil, ServiceError.parsing("Failed to load"))
            return
        }
        
        do {
            let e: T? = try parser.parse(data)
            fetchResult(e, nil)
        } catch {
            fetchResult(nil, ServiceError(from: error))
        }
    }
}
