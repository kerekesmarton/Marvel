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
    
    public var userProfileStore: UserProfileStoring {
        return MockUserProfileStore()
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
    public var privateKey: String? = "something"
    
    private var _id: String? = "5c790677f05d200009557354"
    public var id: String? {
        get {
            let info: ProcessInfo = ProcessInfo()
            if info.isUITesting {
                return info.environment["signedInUserID"]
            } else {
                return _id
            }
        }
        set {
            _id = newValue
        }
    }
    public var publicKey: String? = "eyJraWQiOiJzekVRaThLMG5yN0RNcEhmREdYV040Tk9hSHlpWEJFWmxyQnNuUlZITThzPSIsImFsZyI6IlJTMjU2In0.eyJzdWIiOiJkYzcxZGJjMi0yMjY4LTQ5MTgtYWRjOS0zYjZiZWRhM2M5YjEiLCJlbWFpbF92ZXJpZmllZCI6dHJ1ZSwidGVuYW50S2V5IjoiY29ubmVjdHQuc29jaWFsLmRldjAxLmNvbm5lY3R0LmNsb3VkIiwiaXNzIjoiaHR0cHM6XC9cL2NvZ25pdG8taWRwLmV1LXdlc3QtMS5hbWF6b25hd3MuY29tXC9ldS13ZXN0LTFfQTZhYjRJVXJpIiwiY29nbml0bzp1c2VybmFtZSI6ImRjNzFkYmMyLTIyNjgtNDkxOC1hZGM5LTNiNmJlZGEzYzliMSIsInVzZXJJZCI6IjU0YTUxODQyLTI1NmMtNDUxYy1hZmVkLWNiZTA5YmZkMWJmMCIsImN1c3RvbTp1c2VySWQiOiI1NGE1MTg0Mi0yNTZjLTQ1MWMtYWZlZC1jYmUwOWJmZDFiZjAiLCJhdWQiOiI2aTIzZDc4aDIwaDNrZjQxbzZoY2kzZWloYiIsImV2ZW50X2lkIjoiZjY4MzM4NzItYzM2Ni00NGMwLWFiNGYtNGZjZDA1ODYxZDhjIiwidG9rZW5fdXNlIjoiaWQiLCJhdXRoX3RpbWUiOjE1NjgwMjUxNjMsInRlbmFudElkIjoiOTM1NTZjNTUtYTc3NC00ZGRmLTg1YzItNDE2N2IwMzZlZTQ0IiwiZXhwIjoxNTY4MDI4NzYzLCJpYXQiOjE1NjgwMjUxNjMsImVtYWlsIjoidGVzdCtzb2NpYWxAY29ubmVjdHQudXMifQ==.Q_ZoXVjrdhxUFcE1L_xPtzEMgoCyL_8JPBxsoRxd8g4J_QgeWU0ON5DG_rvtCaT68jRcnV_gh9IPycDGj0EahUHok93aS_5q1Q9TVEnhjVfItQrZKxNW8v3RFUabETdSKT4xQMuP_bcwJWsMHeEoFBtgTA6sD_BV514NDIb5J-k_0KHYZk6VSpn9QBRr_kmxA8XWpiAZ3T4jriOdfz4Lp8zomjtV8lMzkKqBrDWbSMmEwEWPtRdYTvMNwHjNxbnYR-3ZfX76XhmgI7N24LHbjndGc-ryNDPfce4Kw0tahps8MrPkjSyeqC6yJIPWh5BL4GOio_n_tHe9Xm6OTcgypg"
    public var chatToken: String? = ""
    public var avatar: URL? = URL(string: "https://avatar-cdn.atlassian.com/302a14c3480399e1fc7b450ea51d9196?s=128")
    public init() {}
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
