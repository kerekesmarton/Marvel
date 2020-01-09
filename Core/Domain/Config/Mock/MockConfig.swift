//
//  Domain
//
//  Copyright © 2018 mkerekes. All rights reserved.
//

import Foundation
import Photos
import UserNotifications
import Additions

public class MockConfig: Configurable {
    
    public var notificationServices: NotificationServiceable  & NotificationRefreshable {
        get {
            return MockNotificationServiceable()
        }
        set {}
    }
    
    public static let shared = MockConfig()
    
    private init(){}
    
    var sessionRequired = false
    
    public var session: Sessionable {
        return URLSession.shared
    }
    
    public var featureFlags: FeatureFlags? {
        return nil
    }
    
    public var photosFetching: PhotosDataFetching {
        return MockPhotosStore()
    }
    
    public var spyLoadConfiguration = 0
    public var spyDidFinish: (()-> Void)?
    public func loadConfiguration(didFinish: @escaping () -> Void) {
        spyLoadConfiguration += 1
        spyDidFinish = didFinish
        spyDidFinish?()
    }
    
    public var spyBlock: (()-> Void)?
    public func addToLoad(block: @escaping () -> Void) {
        spyBlock = block
        block()
    }
    
    public var keychain: (KeychainLoading & SessionCleaning) {
        return MockKeychain()
    }
    
    public var uniqueStringProviding: UniqueStringProviding {
        return MockUniqueStringProviding(defaults: UserDefaults.standard)
    }
    
    public var userProfileStore: UserProfileStoring {
        return MockUserProfileStore(defaults: UserDefaults.standard)
    }
    
    public var appModules: ApplicationModules = ModuleTable.shared
    
    public var settings: SettingsConfigurable = MockSettingsConfigurable(defaults: UserDefaults.standard)
}

extension URLSession: Sessionable {}


class MockKeychain: KeychainLoading & SessionCleaning {
    var id: String?
    
    var token: String?
    
    func saveToken(_ value: String) {}
    
    var hasSession: Bool = false
    
    func deleteSession() {}
    
    func deleteUserId() {}
}

public class MockUserProfileStore: UserProfileStoring {
    public var privateKey: String?
    public var publicKey: String?
    
    public init(defaults: DefaultSettings) {
        privateKey = defaults.string(forKey: "privateKey")
        publicKey = defaults.string(forKey: "publicKey")
    }
}

class MockPhotosStore: PhotosDataFetching {
    
    func image(for asset: PHAsset, with size: CGSize, completionHandler: @escaping PhotoFetchingCompletion, progressHandler: UpdateBlock?) {
        completionHandler(Media.Image(data: Data()), "")
    }
    
    func video(for asset: PHAsset, completionHandler: @escaping VideoFetchingCompletion, progressHandler: UpdateBlock?) {
        completionHandler(Media.Video(url: URL(string: "somevideo.com")!, data: Data()), "")
    }
    
}

class MockTokenParser: TokenParsing {
    init() {}
    var stubEmail = "email"
    var stubExpTime = 100
    func parse(token: String) throws -> Token {
        return Token(body: Token.Body(email: stubEmail,
                                      tenantId: "a",
                                      exp: stubExpTime,
                                      userId: "a"),
                     signature: "a",
                     string: "a")
    }

}

class MockNotificationServiceable: NotificationServiceable  & NotificationRefreshable {
    
    var shouldShowRedDotOnNotificationsTab: Bool?
    
    var helper: Any!
    
    var config: Configurable?
    
    func setupAWSservices(with launchOptions: [UIApplication.LaunchOptionsKey : Any]?) {}
    
    func registerForPushNotifications() {}
    
    func updateEndpoint(userId: String) {}
    
    func didRegisterForRemoteNotificationsWith(token: Data) {}
    
    func didReceiveRemoteNotification(userInfo: [AnyHashable: Any],
                                      fetchCompletionHandler completionHandler:
        @escaping (BackgroundFetchResult) -> Void) {}
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {}
    
    func forwardNotifications(userInfo: [AnyHashable : Any]) {}
}

public class MockUniqueStringProviding: UniqueStringProviding {
    public var uniqueString: String
    
    public init(defaults: DefaultSettings) {
        self.uniqueString = defaults.string(forKey: "ts")!
    }
}

final class MockDefaultSettings: DefaultSettings {
    func bool(forKey defaultName: String) -> Bool {
        return true
    }
    
    func string(forKey defaultName: String) -> String? {
        return ""
    }
    
    func set(_ value: Any?, forKey defaultName: String) {}
    
    func synchronize() -> Bool { return true }
}
