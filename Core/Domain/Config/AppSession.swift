//
//  Domain
//
//  Copyright © 2018 mkerekes. All rights reserved.
//

import Foundation

public protocol AppSessionable {
    func userIsLoggedIn() -> Bool
    func logoutUser()
    func refreshSession(completion: @escaping (Bool, ServiceError?) -> Void)
    func refreshNeeded() -> Bool
    func refreshNeededForResume() -> Bool
}

public class AppSession: AppSessionable {
    var userStore: UserProfileStoring
    var parser: TokenParsing
    var service: SpecialisedDataService?
    public init(userRepository: UserProfileStoring, parser: TokenParsing) {
        self.userStore = userRepository
        self.parser = parser
        self.service = nil
    }
    
    public func userIsLoggedIn() -> Bool {
        return userStore.id != nil
    }
    
    public func logoutUser() {
        userStore.id = nil
        userStore.avatar = nil
        userStore.token = nil
        userStore.refresh = nil
    }
    
    public func refreshNeeded() -> Bool {
        guard !ProcessInfo().isUITesting else {
            return false
        }
        
        guard let tokenString = userStore.token else { return  false} // not signed in yet, can't get here
        
        do {
            let token = try parser.parse(token: tokenString)
            guard let expTimeInterval = TimeInterval(exactly: Double(token.body.exp)) else { return false} //incorrect data, shouldn't get here
            let expDate = Date(timeIntervalSince1970: expTimeInterval)
            if expDate < Date() {
                return true
            }
            else {
                return false
            }
        }
        catch {
            return false
        }
    }
    
    public func refreshNeededForResume() -> Bool {
        guard let tokenString = userStore.token else { return  false} // not signed in yet, can't get here
        
        do {
            let token = try parser.parse(token: tokenString)
            guard let expTimeInterval = TimeInterval(exactly: Double(token.body.exp)) else { return false} //incorrect data, shouldn't get here
            let expDate = Date(timeIntervalSince1970: expTimeInterval + 30 * 60)
            if expDate < Date() {
                return true
            } else {
                return false
            }
        } catch {
            return false
        }
    }
    
    public func refreshSession(completion: @escaping (Bool, ServiceError?) -> Void) {
//        guard let token = userStore.refresh else {
//            completion(false, ServiceError.unknown)
//            return
//        }
//        userStore.id = token.body.userId
//        userStore.token = token.token
//        userStore.refresh = token.refreshToken
        completion(true, nil)
    }
    
    
}
