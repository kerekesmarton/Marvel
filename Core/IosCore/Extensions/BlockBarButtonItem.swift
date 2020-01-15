//
//  UIBarButtonItem.swift
//  IosCore
//
//  Created by Marton Kerekes on 15/01/2020.
//  Copyright © 2020 Marton Kerekes. All rights reserved.
//

import UIKit
import Presentation

public class BlockBarButtonItem: UIBarButtonItem {
    
    var actionHandler: Tap?
    
    public init(title: String?, style: UIBarButtonItem.Style, action: @escaping Tap) {
        actionHandler = action
        super.init()
        target = self
        self.action = #selector(barButtonItemPressed(sender:))
        self.title = title        
        self.style = style
    }
    
    public init(image: UIImage?, style: UIBarButtonItem.Style, action: @escaping Tap) {
        actionHandler = action
        super.init()
        target = self
        self.action = #selector(barButtonItemPressed(sender:))
        self.image = image
        self.style = style
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func barButtonItemPressed(sender: UIBarButtonItem) {
        actionHandler?()
    }
}
