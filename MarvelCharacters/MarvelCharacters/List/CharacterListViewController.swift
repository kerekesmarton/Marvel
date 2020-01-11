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
    var searchController: UISearchController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        applyStyle()
        collectionView.showsVerticalScrollIndicator = false
        collectionView.bounces = false
        registerCell(cellClass: ProfileCollectionViewCell.self, with: collectionView)
        emptyStateDelegate = self
        emptyStateDataSource = self
        if let image = UIImage(named: "General-logo") { //not using image literal for testability purposes
            setLogoInNavigation(image: image)
        }
        
        searchController?.searchBar.delegate = self
        searchController?.searchResultsUpdater = self
        searchController?.obscuresBackgroundDuringPresentation = false
        searchController?.searchBar.placeholder = ""
        
        definesPresentationContext = true
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = searchController
        edgesForExtendedLayout = .all
        
        presenter.viewReady()
    }
    
    func reload() {
        collectionView.reloadData()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter?.itemCount ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfileCollectionViewCell", for: indexPath) as? ProfileCollectionViewCell else {
            fatalError()
        }
        presenter.setup(cell: cell, at: indexPath.row)
        if indexPath.row == presenter.itemCount - 1 {
            presenter.viewDidReachEnd()
        }
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? CharacterPresentingItem else {
            return
        }
        presenter.didSelect(cell: cell, at: indexPath.row)
    }
}

extension CharacterListViewController: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                               sizeForItemAt indexPath: IndexPath) -> CGSize {
        let w = traitCollection.horizontalSizeClass == .compact ? collectionView.bounds.width * 0.45 : collectionView.bounds.width * 0.2
        let h = w * 4 / 3
        return CGSize(width: w, height: h)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                               insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    }
    
    public func collectionView(_ collectionView: UICollectionView,
                               layout collectionViewLayout: UICollectionViewLayout,
                               minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return collectionView.bounds.width * 0.05
    }
}

extension CharacterListViewController: EmptyStateDataSource, EmptyStateDelegate {
    
    func emptyStateViewShouldShow(for collectionView: UICollectionView) -> Bool {
        return presenter.emptyStateShouldShow
    }
    
    var emptyStateTitle: NSAttributedString {
        return presenter.emptyStateTitle
    }
    
    var emptyStateDetailMessage: NSAttributedString? {
        return presenter.emptyStateTitleDetail
    }
    
    var emptyStateButtonModel: SecondaryActionButton.DataModel? {
        guard let buttonTitle = presenter.emptyStateButtonTitle else  { return nil }
        return.filled(text: buttonTitle, image: nil)
    }
    
    var emptyStateButtonSize: CGSize? {
        return CGSize(width: 160, height: 40)
    }
    
    func emptyStatebuttonWasTapped(button: UIButton) {
        presenter.didTapEmptyStateButton()
    }
}

extension CharacterListViewController: UISearchBarDelegate, UISearchResultsUpdating {
    public func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        presenter.didCancel()
    }
    
    public func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text, text.length > 0 else {
            presenter.viewReady()
            return
        }
        presenter.didUpdate(searchTerm: text)
    }
}

extension ProfileCollectionViewCell: CharacterPresentingItem {}
