//
//  ModuleDeclarations.swift
//  IosCore
//
//  Created by Marton Kerekes on 07/01/2020.
//  Copyright © 2020 Marton Kerekes. All rights reserved.
//

import UIKit
import Domain

public protocol SeriesListModuleable: Module {
    func setup(type: SeriesListType, config: Configurable) -> (router: Routing, viewController: UIViewController)
}
