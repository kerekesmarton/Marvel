//
//  Created by Marton Kerekes on 07/01/2020.
//  Copyright © 2020 Marton Kerekes. All rights reserved.
//

import Foundation
import Domain
import Presentation

protocol SeriesPresentingItem {
    func setup(info: PresentableInfo, title: String?, imageURL: URL?, type: ListType)
}

protocol SeriesListPresenting {
    func viewReady()
    func viewDidReachEnd(index: IndexPath)
    var itemCount: Int { get }
    func setup(cell: SeriesPresentingItem, at index: Int)
    func didSelect(cell: SeriesPresentingItem, at index: Int)
    func didTapEmptyStateButton()
    var emptyStateTitle: NSAttributedString { get }
    var emptyStateTitleDetail: NSAttributedString? { get }
    var emptyStateButtonTitle: String? { get }
    var emptyStateShouldShow: Bool { get }
}

protocol SeriesListPresentationOutput: FontCalculating {
    func reload()
}

protocol SeriesListRouting: ErrorRouting {
    func routeSeries(_ story: Entities.Series)
}

class SeriesListPresenter: SeriesListPresenting {
    weak var output: SeriesListPresentationOutput!
    let router: SeriesListRouting
    let fetcher: SeriesListFetching
    let type: SeriesListType
    
    init(type: SeriesListType, fetcher: SeriesListFetching, router: SeriesListRouting) {
        self.type = type
        self.fetcher = fetcher
        self.router = router
    }
    
    var results: Entities.SeriesDataWrapper? {
        didSet {
            output.reload()
        }
    }
    
    var unwrappedItems: [Entities.Series]? {
        return results?.data?.results
    }
    
    func viewReady() {
        output.reload()
        
        fetcher.fetchStories(type: type) { [weak self] (result) in
            do {
                self?.results = try result.get()
            } catch {
                self?.router.route(message: .error(ServiceError(from: error)))
            }
        }
    }
    
    var lastLoaded: IndexPath? = nil
    func viewDidReachEnd(index: IndexPath) {
        guard let results = results, lastLoaded != index else { return }
        lastLoaded = index
        fetcher.fetchNext(result: results) { [weak self] (result) in
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
    
    func setup(cell: SeriesPresentingItem, at index: Int) {
        guard let item = unwrappedItems?[index], let name = item.title else { return }
        
        var text = [FontCalculable(text: name, style: .largeAuthor), ]
        if let desc = item.description {
            text.append(FontCalculable(text: desc, style: .normal))
        }
        let info = BasicInfo(displayableText: text, tick: false)
        let profileInfo = PresentableInfo(info: info, helper: output)
        
        let url = item.thumbnail?.createURL(size: .portrait_uncanny)
        
        cell.setup(info: profileInfo, title: item.description, imageURL: url, type: .none)
    }
    
    
    func didSelect(cell: SeriesPresentingItem, at index: Int) {
        guard let item = unwrappedItems?[index] else { return }
        router.routeSeries(item)
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
