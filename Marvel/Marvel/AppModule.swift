///
//  Copyright © 2018 mkerekes. All rights reserved.
//

import Foundation
import Domain
import Presentation
import IosCore
import Data

class AppModule: Module {
    func setup(config: Configurable) -> (presenter: AppPresenter, router: AppRouter) {
        
        let appRouter = AppRouter(windowSource: WindowSource(), style: DemoAppStyle())
        var settingsInteractor: SettingsConfigurable = config.settings    
        let sessionInteractor: AppSession = AppSession(userRepository: config.userProfileStore,
                                                       parser: TokenParser())
        
        let appPresenter = AppPresenter(router: appRouter,
                                        config: config,
                                        interactor: sessionInteractor,
                                        settingsInteractor: settingsInteractor,
                                        notifications: NotificationsWrapper.shared,
                                        userRepository: config.userProfileStore)
        
        settingsInteractor.delegate = appPresenter
        appRouter.delegate = appPresenter
        
        return (appPresenter, appRouter)
    }
}
