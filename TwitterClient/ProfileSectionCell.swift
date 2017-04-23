//
//  ProfileSectionCell.swift
//  TwitterClient
//
//  Created by Sethi, Pinkesh on 4/23/17.
//  Copyright © 2017 Sethi, Pinkesh. All rights reserved.
//

import UIKit

class ProfileSectionCell: UITableViewCell {

    @IBOutlet weak var profileTweetCount: UILabel!
    @IBOutlet weak var profileFollowerCount: UILabel!
    @IBOutlet weak var profileFollowingCount: UILabel!
    @IBOutlet weak var profileScreenNameLabel: UILabel!
    @IBOutlet weak var profileUserNameLabel: UILabel!
    @IBOutlet weak var profileThumbImageView: UIImageView!
    @IBOutlet weak var profileBannerImageView: UIImageView!
    
    var user: User!{
        didSet{
            profileTweetCount.text = "\((user?.tweetCount)!)"
            profileFollowerCount.text = "\((user?.followersCount)!)"
            profileFollowingCount.text = "\((user?.followingCount)!)"
            profileUserNameLabel.text = user?.name
            profileScreenNameLabel.text = user?.screenName
            profileThumbImageView.setImageWith((user?.profilePhotoUrl)!)
            profileBannerImageView.setImageWith((user?.profileBannerUrl)!)
            
            profileThumbImageView.layer.cornerRadius = 10.0
            profileThumbImageView.layer.masksToBounds = true
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
