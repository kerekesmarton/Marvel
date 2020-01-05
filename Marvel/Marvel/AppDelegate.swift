//
//  AppDelegate.swift
//  Marvel
//
//  Created by Marton Kerekes on 03/01/2020.
//  Copyright © 2020 Marton Kerekes. All rights reserved.
//

import UIKit
import IosCore
import Presentation
import Domain
import Data
import Additions
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var appRouter: AppRouter!
    var appPresenter: AppPresenting!
    var helper: NotificationServicesHelper!
    var orientationLock = UIInterfaceOrientationMask.portrait
    let config: Configuration = Configuration.shared
    
    private func setupApplication() {
        guard !TestHelper.isTesting else {
            return
        }
        
        //setup dependency injection
        let config: Configuration = Configuration.shared
        config.settings.register()
        DependencyInjection().injectDependencies(in: config.appModules)
        
        //launch app
        let appModule: AppModule = config.appModules.module()
        let result = appModule.setup(config: config)
        appPresenter = result.presenter
        appRouter = result.router
        helper = NotificationServicesHelper(appPresenter: appPresenter)
        appPresenter.loadApplication()
    }
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        setupApplication()
        if let launchOptions = launchOptions {
            helper.processOtherArguments(from: launchOptions)
        }

        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func application(_ application: UIApplication,
                     continue userActivity: NSUserActivity,
                     restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        let deepLink = DeepLinkOption<Void>.activity(userActivity)
        appPresenter.link(with: deepLink)
        return true
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        appPresenter.applicationWillEnterForeground()
    }
    
    func application(_ application: UIApplication,
                     supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return self.orientationLock
    }
}

extension AppRouter: LogoutResponder {
    public func didLogout() {
        delegate?.setNeedsRestart()
    }
}

extension AppRouter: OrientationLocking {
    public func lockOrientation(_ orientation: UIInterfaceOrientationMask) {
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            delegate.orientationLock = orientation
        }
    }
    
    public func lockOrientation(_ orientation: UIInterfaceOrientationMask,
                                andRotateTo rotateOrientation: UIInterfaceOrientation) {
        self.lockOrientation(orientation)
        UIDevice.current.setValue(rotateOrientation.rawValue, forKey: "orientation")
    }
}
