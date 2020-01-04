//
//  CharacterListViewController.swift
//  Characters
//
//  Created by Marton Kerekes on 04/01/2020.
//  Copyright © 2020 Marton Kerekes. All rights reserved.
//

import Foundation
import IosCore
import Presentation

class CharacterListViewController: CollectionViewController, CharacterListPresentationOutput {
    
    var presenter: CharacterListPresenting!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.viewReady()
    }
    
    override func applyStyle() {
        super.applyStyle()
    }
    
    func reload() {
        
    }
}
