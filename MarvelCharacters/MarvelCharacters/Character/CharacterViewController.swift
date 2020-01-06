//
//  CharacterViewController.swift
//  MarvelCharacters
//
//  Created by Marton Kerekes on 06/01/2020.
//  Copyright © 2020 Marton Kerekes. All rights reserved.
//

import Foundation
import IosCore
import Presentation

class CharacterViewController: SegmentedHeaderViewController, CharacterPresentationOutput {
    var presenter: CharacterPresenting!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        enableCoverView = false
        presenter.viewReady()        
    }
    
    override func applyStyle() {
        super.applyStyle()
    }
    
    var headerView: CharacterHeaderViewProtocol? {
        return contentView as? CharacterHeaderViewProtocol
    }
    
    override func setupContentView(_ _mainScrollView: UIScrollView) {
        let nib = UINib(nibName: String(describing: CharacterHeaderView.self), bundle: Bundle(for: CharacterHeaderView.self))
        let views = nib.instantiate(withOwner: self, options: nil)
        if let _characterHeaderView = views.first as? CharacterHeaderView  {
            _mainScrollView.addSubview(_characterHeaderView)
            contentView = _characterHeaderView
        }
    }
    
    func reload() {
        headerView?.profileTapClosure = { [weak self] in
            self?.presenter.didTapProfileImage(referenceViewable: self?.headerView)
        }
    }
    
    func setTitle(_ title: String) {
        self.title = title
    }
    
    func setImage(url: URL) {
        headerView?.setProfileImage(url: url)
    }
    
    func setHeader(description: String) {
        headerView?.setText(description)
    }
    
}
