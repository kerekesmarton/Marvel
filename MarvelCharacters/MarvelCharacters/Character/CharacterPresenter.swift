//
//  CharacterPresenter.swift
//  MarvelCharacters
//
//  Created by Marton Kerekes on 06/01/2020.
//  Copyright © 2020 Marton Kerekes. All rights reserved.
//

import Foundation
import Domain
import Presentation

protocol CharacterPresenting {
    func viewReady()
    func didTapProfileImage(referenceViewable: ImageReferenceCalculating?)
}

protocol CharacterPresentationOutput: FontCalculating, CharacterPresentingItem {
    func reload()
    func setTitle(_ title: String)
}

protocol CharacterRouting: CameraRouting {
    
}

class CharacterPresenter: CharacterPresenting {
    
    weak var output: CharacterPresentationOutput!
    let router: CharacterRouting
    let character: Entities.Character
    init(router: CharacterRouting, character: Entities.Character) {
        self.router = router
        self.character = character
    }
    
    func viewReady() {
        output.reload()
        if let name = character.name {
            output.setTitle(name)
            
            var text = [FontCalculable(text: name, style: .largeAuthor), ]
            if let desc = character.description {
                text.append(FontCalculable(text: desc, style: .normal))
            }
            let info = BasicInfo(displayableText: text, tick: false)
            let profileInfo = PresentableInfo(info: info, helper: output)
            
            let url = character.thumbnail?.createURL(size: .full)
            
            output.setup(info: profileInfo, title: character.description, imageURL: url, type: .none)
        }
        
    }
    
    func didTapProfileImage(referenceViewable: ImageReferenceCalculating?) {
        guard let url = character.thumbnail?.createURL(size: .full), let name = character.name else { return }
        let firstLine = [FontCalculable(text: name, style: FontStyle.author)]
        let assets = [RemoteAsset(url: url, caption: firstLine, secondCaption: [])]
        router.showViewer(for: assets, startIndex: 0, reference: referenceViewable)
    }
    
}
