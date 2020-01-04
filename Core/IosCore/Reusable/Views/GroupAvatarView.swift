//
//  IosCore
//
//  Copyright © 2018 mkerekes. All rights reserved.
//

import UIKit
import SnapKit
import Kingfisher

final public class GroupAvatarView: UIView, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    fileprivate var avatarURLs: [URL] = []
    fileprivate var avatarCollectionView: UICollectionView?
    fileprivate var totalImagesToDisplay: Int = 3
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        let flowLayout = AvatarCollectionViewLayout()
        
        avatarCollectionView = UICollectionView(frame: self.bounds, collectionViewLayout: flowLayout)
        avatarCollectionView?.dataSource = self
        avatarCollectionView?.backgroundColor = UIColor.clear
        avatarCollectionView?.register(UICollectionViewCell.classForCoder(), forCellWithReuseIdentifier: "AvatarCell")
        addSubview(avatarCollectionView!)
        
        avatarCollectionView?.translatesAutoresizingMaskIntoConstraints = false
        
        snp.makeConstraints { (builder) in
            builder.left.equalTo(self)
            builder.top.equalTo(self)
            builder.right.equalTo(self)
            builder.bottom.equalTo(self)
        }
        
        setNeedsUpdateConstraints()
    }
    
    //MARK: Public
    /**
     Set list of avatar (NSURL), the avatar'll be downloaded from the url. (use framework SDWebImage)
     - Parameters:
     + urls: List of avatars (3 item at most)
     */
    public func set(avatarURLs: [URL]) {
        self.avatarURLs = avatarURLs
        avatarCollectionView?.reloadData()
    }
    
    public func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AvatarCell", for: indexPath)
        for subview in cell.subviews {
            subview.removeFromSuperview()
        }
        let imageView = UIImageView(frame: cell.bounds)
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = imageView.frame.size.width / 2
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.clipsToBounds = true
        imageView.backgroundColor = .gray
        
        let imageURL = avatarURLs[safe: indexPath.row]
        imageView.kf.setImage(with: imageURL)
        
        cell.addSubview(imageView)
        
        cell.backgroundColor = UIColor.clear
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return min(avatarURLs.count, totalImagesToDisplay)
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
    
}

private class AvatarCollectionViewLayout : UICollectionViewLayout {
    
    private var cache: [UICollectionViewLayoutAttributes] = []
    
    override func prepare() {
        super.prepare()
        cache.removeAll()
        guard let view = collectionView else { return }
        if view.numberOfItems(inSection: 0) > 0 {
            for index in 0...(view.numberOfItems(inSection: 0) - 1) {
                let indexPath = IndexPath(item: index, section: 0)
                let attribute = calculateCellLayoutAttribute(indexPath)
                cache.append(attribute)
            }
        }
    }
    
    private func calculateCellLayoutAttribute(_ indexPath: IndexPath) -> UICollectionViewLayoutAttributes {
        let attribute = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        guard let view = collectionView else { return attribute }
        
        var frame = view.frame
        
        frame.size = CGSize(width: collectionView!.frame.width * 0.4, height: collectionView!.frame.height)
        
        switch indexPath.row {
        case 0:
            frame.origin = CGPoint.zero
        case 1:
            frame.origin = CGPoint(x: collectionView!.frame.width * 0.2, y: CGPoint.zero.y)
        case 2:
            frame.origin = CGPoint(x: collectionView!.frame.width * 0.4, y: CGPoint.zero.y)
        default:
            break
        }
        
        attribute.frame = frame
        
        return attribute
    }
    
    override var collectionViewContentSize: CGSize {
        guard let view = collectionView else { return .zero }
        return view.frame.size
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return cache.filter { $0.frame.intersects(rect) }
    }
    
}
