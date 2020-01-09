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
    func segments() -> [CharacterSegmentedContent]
}

protocol CharacterPresentationOutput: FontCalculating {
    func reload()
    func setTitle(_ title: String)
    func setHeader(description: String)
    func setImage(url: URL)
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
        }
        
        if let url = character.thumbnail?.createURL(size: .full) {
            output.setImage(url: url)
        }        
    }
    
    func didTapProfileImage(referenceViewable: ImageReferenceCalculating?) {
        guard let url = character.thumbnail?.createURL(size: .full), let name = character.name else { return }
        let firstLine = [FontCalculable(text: name, style: FontStyle.author)]
        let assets = [RemoteAsset(url: url, caption: firstLine, secondCaption: [])]
        router.showViewer(for: assets, startIndex: 0, reference: referenceViewable)
    }
    
    func segments() -> [CharacterSegmentedContent] {
        let bio = [FontCalculable(text: character.description ?? "", style: .normal)]
        return [.series(character: character), .bio(text: bio)]
    }
    
}
