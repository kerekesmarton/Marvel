//
//  CharacterListPresenter.swift
//  Characters
//
//  Created by Marton Kerekes on 04/01/2020.
//  Copyright © 2020 Marton Kerekes. All rights reserved.
//

import Foundation
import Domain
import Presentation

protocol CharacterPresentingItem {
    func setup(info: PresentableInfo, title: String?, imageURL: URL?, type: ListType)
}

protocol CharacterListPresenting {
    func viewReady()
    func viewDidReachEnd()
    var itemCount: Int { get }
    func setup(cell: CharacterPresentingItem, at index: Int)
    func didSelect(cell: CharacterPresentingItem, at index: Int)
    func didTapEmptyStateButton()
    var emptyStateTitle: NSAttributedString { get }
    var emptyStateTitleDetail: NSAttributedString? { get }
    var emptyStateButtonTitle: String? { get }
    var emptyStateShouldShow: Bool { get }
    
    func didCancel()
    func didUpdate(searchTerm: String)
}

protocol CharacterListPresentationOutput: FontCalculating {
    func reload()
}

protocol CharacterListRouting: ErrorRouting {
    func route(character: Entities.Character)
}

class CharacterListPresenter: CharacterListPresenting {
    weak var output: CharacterListPresentationOutput!
    let router: CharacterListRouting
    let charecterListFetcher: CharacterListFetching

    init(charecterListFetcher: CharacterListFetching, router: CharacterListRouting) {
        self.charecterListFetcher = charecterListFetcher
        self.router = router
    }
    
    private var results: Entities.CharacterDataWrapper? {
        didSet {
            output.reload()
        }
    }
    
    private var unwrappedItems: [Entities.Character]? {
        return results?.data?.results
    }
    
    func viewReady() {
        charecterListFetcher.fetchCharacters(filter: .all) { [weak self] (result) in
            do {
                self?.results = try result.get()
            } catch {
                self?.router.show(error: ServiceError(from: error))
            }
        }
    }
    
    var lastLoaded: String? = nil
    func viewDidReachEnd() {
        guard let results = results, lastLoaded != results.etag else { return }
        lastLoaded = results.etag
        charecterListFetcher.fetchNext(result: results) { [weak self] (result) in
            do {
                self?.results = try result.get()
            } catch {
                self?.router.show(error: ServiceError(from: error))
            }
        }
    }
    
    var itemCount: Int {
        return unwrappedItems?.count ?? 0
    }
    
    func setup(cell: CharacterPresentingItem, at index: Int) {
        guard let item = unwrappedItems?[index], let name = item.name else { return }
        
        var text = [FontCalculable(text: name, style: .largeAuthor), ]
        if let desc = item.description {
            text.append(FontCalculable(text: " " + desc, style: .normal))
        }
        let info = BasicInfo(displayableText: text, tick: false)
        let profileInfo = PresentableInfo(info: info, helper: output)
        
        let url = item.thumbnail?.createURL(size: .portrait_uncanny)
        
        cell.setup(info: profileInfo, title: item.description, imageURL: url, type: .none)
    }
    
    func didSelect(cell: CharacterPresentingItem, at index: Int) {
        guard let item = unwrappedItems?[index] else { return }
        router.route(character: item)
    }
    
    func didCancel() {
        charecterListFetcher.cancel()
    }
    
    func didUpdate(searchTerm: String) {
        charecterListFetcher.fetchCharacters(filter: .nameStartsWith(searchTerm)) { [weak self] (result) in
            do {
                self?.results = try result.get()
            } catch {
                self?.router.show(error: ServiceError(from: error))
            }
        }
    }
    
    func didTapEmptyStateButton() {
        viewReady()
    }
    
    var emptyStateTitle: NSAttributedString {
        guard let output = output else { return NSAttributedString() }
        return output.makeAttributedString(from: [FontCalculable(text: "list_empty_state_title".localised, style: .mention)])
    }
    
    public var emptyStateTitleDetail: NSAttributedString? {
        guard let view = output else { return NSAttributedString() }
        return view.makeAttributedString(from: [FontCalculable(text: "list_empty_state_details".localised, style: .normal)])
    }
    
    public var emptyStateButtonTitle: String? {
        return "list_empty_state_button".localised
    }
    
    public var emptyStateShouldShow: Bool {
        guard let results = unwrappedItems else { return false }
        return results.count == 0
    }
    
    
}
