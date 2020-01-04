///
//  IosCore
//
//  Copyright © 2018 mkerekes. All rights reserved.
//

import Foundation
import Domain
import Presentation

protocol SettingsPresentable {
    func setup(title: String)
}

protocol SettingsPresenting {
    var numberOfRows: Int { get }
    func setup(cell: SettingsPresentable, for index: IndexPath)
    func didTap(cell: SettingsPresentable, at index: IndexPath)
    var title: String { get }
}

protocol SettingsPresentationOutput: class {
   
}

protocol SettingsRouting {
    func route(settings: Settings, animated: Bool)
}

class SettingsPresenter: SettingsPresenting {
    
    weak var output: SettingsPresentationOutput!
    let router: SettingsRouting
    
    init(router: SettingsRouting) {
        self.router = router
    }
    
    var options = Settings.allCases
    
    var numberOfRows: Int {
        return options.count
    }
    
    func setup(cell: SettingsPresentable, for index: IndexPath) {
        let item = options[index.row]
        cell.setup(title: item.title)
    }
    
    func didTap(cell: SettingsPresentable, at index: IndexPath) {
        let item = options[index.row]
        router.route(settings: item, animated: true)
    }
    
    var title: String {
        return "settings".localised
    }
}
