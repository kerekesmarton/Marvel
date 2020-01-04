//
//  UI
//
//  Copyright © 2018 mkerekes. All rights reserved.
//

import UIKit

public class ProfileSocialCell: UITableViewCell, Styleable {
    //dzk
    @IBOutlet var postValueLabel: UILabel!
    @IBOutlet var postButton: UIButton!
    
    @IBOutlet weak var followersButton: UIButton!
    @IBOutlet weak var followersValueLabel: UILabel!
    
    @IBOutlet weak var followingButton: UIButton!
    @IBOutlet weak var followingValueLabel: UILabel!
    
    public var postsClosure: (() -> Void)? = nil
    public var followingClosure: (() -> Void)? = nil
    public var followersClosure: (() -> Void)? = nil

    public var dataModel: DataModel? {
        didSet {
            if let followers = dataModel?.followers {
                followersValueLabel.text = followers
                followersButton.isEnabled = true
            } else {
                followersValueLabel.text = "0"
                followersButton.isEnabled = false
            }
            if let following = dataModel?.following {
                followingValueLabel.text = following
                followingButton.isEnabled = true
            } else {
                followingValueLabel.text = "0"
                followingButton.isEnabled = false
            }
            if let posts = dataModel?.posts {
                postValueLabel.text = posts
                postButton.isEnabled = true
            } else {
                postValueLabel.text = "0"
                postButton.isEnabled = false
            }
        }
    }
    
    public func applyStyle() {
        followersValueLabel.textColor = styleProvider?.list?.header.followValueLabel.color
        followersValueLabel.font = styleProvider?.list?.header.followValueLabel.font
        followersButton.setTitleColor(styleProvider?.list?.header.titleOneLabel.color, for: .normal)
        
        followingValueLabel.textColor = styleProvider?.list?.header.followValueLabel.color
        followingValueLabel.font = styleProvider?.list?.header.followValueLabel.font
        followingButton.setTitleColor(styleProvider?.list?.header.titleOneLabel.color, for: .normal)
        
        postValueLabel.textColor = styleProvider?.list?.header.followValueLabel.color
        postValueLabel.font = styleProvider?.list?.header.followValueLabel.font
        postButton.setTitleColor(styleProvider?.list?.header.titleOneLabel.color, for: .normal)
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        applyStyle()
    }
    
    public func setupTitles(posts: String?, following: String?, followers: String?) {
        postValueLabel.text = posts
        followingValueLabel.text = following
        followersValueLabel.text = followers
    }

    @IBAction func didTapPosts(_ sender: UIButton) {
        postsClosure?()
    }
    
    @IBAction func didTapFollowing(_ sender: UIButton) {
        followingClosure?()
    }

    @IBAction func didTapFollowers(_ sender: UIButton) {
        followersClosure?()
    }
    
    public struct DataModel {
        let followers: String?
        let following: String?
        let posts: String?
        public init(followers: String?, following: String?) {
            self.followers = followers
            self.following = following
            self.posts = "10" 
        }
    }
}
