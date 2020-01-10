//
//  Created by Marton Kerekes on 07/01/2020.
//  Copyright © 2020 Marton Kerekes. All rights reserved.
//

import UIKit
import IosCore
import Presentation


class SeriesListViewController: CollectionViewController, SeriesListPresentationOutput {
    
    var presenter: SeriesListPresenting!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.showsVerticalScrollIndicator = false
        collectionView.bounces = false
        registerCell(cellClass: ProfileCollectionViewCell.self, with: collectionView)
        emptyStateDelegate = self
        emptyStateDataSource = self
        setLogoInNavigation(image: #imageLiteral(resourceName: "General-logo"))
        
        presenter.viewReady()
        updateSegmentDelegate()
    }
    
    private func updateSegmentDelegate() {
        DispatchQueue.main.async {
            self.delegate?.didUpdate(self.collectionView)
        }
    }
    
    override func applyStyle() {
        super.applyStyle()
    }
    
    func reload() {
        collectionView.reloadData()
        updateSegmentDelegate()
    }
    
        
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter?.itemCount ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfileCollectionViewCell", for: indexPath) as? ProfileCollectionViewCell else {
            fatalError()
        }
        presenter.setup(cell: cell, at: indexPath.row)
        if indexPath.row == presenter.itemCount - 1, delegate == nil {
            presenter.viewDidReachEnd(index: indexPath)
        }
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? SeriesPresentingItem else {
            return
        }
        presenter.didSelect(cell: cell, at: indexPath.row)
    }
    
    weak var delegate: SegmentsRoutableChildDelegate?
    var lastVisibleIndex: IndexPath?
}

extension SeriesListViewController: UICollectionViewDelegateFlowLayout {
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

extension SeriesListViewController: EmptyStateDataSource, EmptyStateDelegate {
    
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

extension SeriesListViewController: SegmentsRoutableChild {
    var routableScrollView: UIScrollView? {
        get { return collectionView }
    }
    
    func didScroll(to index: IndexPath) {
        if index.row == presenter.itemCount - 1, index != lastVisibleIndex {
            lastVisibleIndex = index
            presenter.viewDidReachEnd(index: index)
        }
    }
}

extension ProfileCollectionViewCell: SeriesPresentingItem {}
