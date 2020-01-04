///
//  Core
//
//  Copyright © 2018 mkerekes. All rights reserved.
//

import Foundation
import Domain
import Presentation
import UserNotifications

class NotificationServicesInstance: NSObject, UNUserNotificationCenterDelegate, NotificationServiceable {
    
//    var pinpoint: AWSPinpoint?
    static let shared = NotificationServicesInstance()
    var helper: Any!
    var config: Configurable?
    let userDefaults = UserDefaults(suiteName: "group.co.mkerekes.salsette")
    
    private let badgeKey = "notificationsTab.badge"
    public var shouldShowRedDotOnNotificationsTab: Bool? {
        get {
            return userDefaults?.bool(forKey: badgeKey)
        }
        set {
            guard let newValue = newValue else {
                userDefaults?.removeObject(forKey: badgeKey)
                return
            }
            userDefaults?.set(newValue, forKey: badgeKey)
        }
    }
    
    func didRegisterForRemoteNotificationsWith(token: Data) {
//        if let pinpoint = pinpoint {
//            pinpoint.notificationManager.interceptDidRegisterForRemoteNotifications(withDeviceToken: token)
//        }
    }
    
    func didReceiveRemoteNotification(userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (BackgroundFetchResult) -> Void) {
        shouldShowRedDotOnNotificationsTab = true
        if let notificationsHelper = helper as? NotificationServicesHelper {
            notificationsHelper.appPresenter.showRedDotOnNotificationsTab()
        }
//        guard pinpoint != nil else {
//            completionHandler(.noData)
//            return
//        }
        completionHandler(.newData)
//        pinpoint!.notificationManager.interceptDidReceiveRemoteNotification(userInfo) { (result) in
//            switch result {
//            case .failed:
//                completionHandler(.failed)
//            case .newData:
//                completionHandler(.newData)
//            case .noData:
//                completionHandler(.noData)
//            @unknown default:
//                completionHandler(.noData)
//            }
//        }
    }
    
    func forwardNotifications(userInfo: [AnyHashable : Any]) {
        guard let notificationsHelper = helper as? NotificationServicesHelper else { return }
        if let data = userInfo["data"] as? [String : Any], let pinpoint = data["pinpoint"] as? [String : Any], let deepLink = pinpoint["deeplink"] as? String, let url = URL(string: deepLink), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
        guard let json = userInfo as? [String: AnyObject],
            let data = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted),
            let pushNotification = try? JSONDecoder().decode(PushNotification.self, from: data),
            let linkValue =  pushNotification.data.linkValue else { return }
        
        notificationsHelper.appPresenter.link(with: DeepLinkOption<Void>.deeplink(linkValue))
    }
    
    func setupAWSservices(with launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        // Create AWSMobileClient to connect with AWS
//        AWSMobileClient.default().initialize { (userState, error) in
//            if let error = error {
//                print("Error initializing AWSMobileClient: \(error.localizedDescription)")
//            } else if let userState = userState {
//                print("AWSMobileClient initialized. Current UserState: \(userState.rawValue)")
//            }
//        }
//
//        // Initialize Pinpoint
//        let pinpointConfiguration = AWSPinpointConfiguration.defaultPinpointConfiguration(launchOptions: launchOptions)
//        pinpoint = AWSPinpoint(configuration: pinpointConfiguration)
    }
    
    // Request user to grant permissions for the app to use notifications
    func registerForPushNotifications() {
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
            (granted, error) in
            guard granted else { return }
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
    
    // This method will be called when app received push notifications in foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)
    {
        if let notificationsHelper = helper as? NotificationServicesHelper {
            notificationsHelper.appPresenter.showRedDotOnNotificationsTab()
        }
        completionHandler([.alert, .badge, .sound])
    }
    
}

extension NotificationServicesInstance: NotificationRefreshable {
    
    func updateEndpoint(userId: String) {
//        if let targetingClient = pinpoint?.targetingClient {
//            let endpoint = targetingClient.currentEndpointProfile()
//            // Create a user and set its userId property
//            let user = AWSPinpointEndpointProfileUser()
//            user.userId = userId
//            // Assign the user to the endpoint
//            endpoint.user = user
//            // Update the endpoint with the targeting client
//            targetingClient.update(endpoint)
//        }
    }
}
