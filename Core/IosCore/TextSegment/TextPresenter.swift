//
//  TextPresenter.swift
//  IosCore
//
//  Created by Marton Kerekes on 08/01/2020.
//  Copyright © 2020 Marton Kerekes. All rights reserved.
//

import Foundation
import Domain
import Presentation

protocol TextPresenting {
    func viewReady()
}

protocol TextPresentationOutput: FontCalculating {
    func reload(text: NSAttributedString)
}

protocol TextRouting {
    
}

class TextPresenter: TextPresenting {
    
    weak var output: TextPresentationOutput!
    let router: TextRouting
    let text: [FontCalculable]
    
    func viewReady() {
        let attributedText = output.makeAttributedString(from: text)
        output.reload(text: attributedText)
    }
    
    init(text: [FontCalculable], router: TextRouting) {
        self.text = text
        self.router = router
    }
}
