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
    
    public func getData<T>(fetchResult: @escaping (Result<T, ServiceError>) -> Void) {
        guard let path = file.path else {
            fetchResult(.failure(ServiceError.parsing("File not found")))
            return
        }
        
        guard let data = data(from: path) as Data? else {
            fetchResult(.failure(ServiceError.parsing("Failed to load")))
            return
        }
        
        do {
            let e: T = try parser.parse(data)
            fetchResult(.success(e))
        } catch {
            fetchResult(.failure(ServiceError(from: error)))
        }
    }
}
