///
//  Core
//
//  Copyright © 2018 mkerekes. All rights reserved.
//

import Domain

public class UserProfileStore: UserProfileStoring {
    
    public init() {}
    
    private let tokenKey = "user.token"
    public var token: String? {
        get {
            guard let token = UserDefaults.standard.string(forKey: tokenKey) else {
                return nil
            }
            return token
        }
        set {
            guard let newValue = newValue else {
                UserDefaults.standard.removeObject(forKey: tokenKey)
                return
            }
            UserDefaults.standard.set(newValue, forKey: tokenKey)
        }
    }
    
    private let refreshKey = "user.refresh"
    public var refresh: String? {
        get {
            guard let token = UserDefaults.standard.string(forKey: refreshKey) else {
                return nil
            }
            return token
        }
        set {
            guard let newValue = newValue else {
                UserDefaults.standard.removeObject(forKey: refreshKey)
                return
            }
            UserDefaults.standard.set(newValue, forKey: refreshKey)
        }
    }
    
    private let chatTokenKey = "user.chatToken"
    public var chatToken: String? {
        get { return UserDefaults.standard.string(forKey: chatTokenKey) }
        set { UserDefaults.standard.set(newValue, forKey: chatTokenKey) }
    }
    
    private let idKey = "user.id"
    public var id: String? {
        get {
            return UserDefaults.standard.string(forKey: idKey)
        }
        set {
            guard let newValue = newValue else {
                UserDefaults.standard.removeObject(forKey: idKey)
                return
            }
            UserDefaults.standard.set(newValue, forKey: idKey)
        }
    }
    
    private let avatarKey = "user.avatar"
    public var avatar: URL? {
        get {
            return URL(string: UserDefaults.standard.string(forKey: avatarKey) ?? "")
        }
        set {
            guard let newValue = newValue?.absoluteString else {
                UserDefaults.standard.removeObject(forKey: avatarKey)
                return
            }
            UserDefaults.standard.set(newValue, forKey: avatarKey)
        }
    }
    
}
