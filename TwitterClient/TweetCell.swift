//
//  TweetCellTableViewCell.swift
//  TwitterClient
//
//  Created by Sethi, Pinkesh on 4/15/17.
//  Copyright © 2017 Sethi, Pinkesh. All rights reserved.
//

import UIKit

@objc protocol TweetCellDelegate{
    func thumbImageTappedAction(senderCell: TweetCell)
}
class TweetCell: UITableViewCell {

    @IBOutlet weak var favoriteImageView: UIImageView!
    @IBOutlet weak var retweetImageView: UIImageView!
    @IBOutlet weak var replyImageView: UIImageView!
    
    @IBOutlet weak var fullNameLabel: UILabel!
    
    @IBOutlet weak var screenNameLabel: UILabel!
    
    @IBOutlet weak var favoriteCountLabel: UILabel!
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var replyCountLabel: UILabel!
    @IBOutlet weak var retweeterIconImageView: UIImageView!
    @IBOutlet weak var retweeterNameLabe: UILabel!
    
    @IBOutlet weak var screenNameLabelTopViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var senderThumbImageView: UIImageView!
    @IBOutlet weak var tweetTimeLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    
    @IBOutlet weak var thumbImageTopViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var timeLabelTopViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var fullNameTopViewConstraint: NSLayoutConstraint!
    
    var tweetCellDelegate: TweetCellDelegate?
    
    var tweet: Tweet!{
        didSet{
            fullNameLabel.text = tweet.senderName
            screenNameLabel.text = tweet.senderScreenName
            if tweet.senderProfileImageUrl != nil{
                senderThumbImageView.setImageWith(tweet.senderProfileImageUrl!)
            }
            
            tweetTextLabel.text = tweet.text
            tweetTimeLabel.text = "\(Tweet.getTimeDifference(currentDate: Date(), oldDate:tweet.timeStamp!))"
            
            favoriteCountLabel.text = "\(tweet.favouritesCount)"
            retweetCountLabel.text = "\(tweet.retweetCount)"
            replyCountLabel.text = "\(tweet.replyCount)"
            if(tweet.favouritesCount>0){
                favoriteImageView.image = #imageLiteral(resourceName: "favorite_sel_ic")
            }else{
                favoriteImageView.image = #imageLiteral(resourceName: "favorite_ic")
            }
            if(tweet.retweetCount>0){
                retweetImageView.image = #imageLiteral(resourceName: "retweet_sel_ic")
            }else{
                retweetImageView.image = #imageLiteral(resourceName: "retweet_ic")
            }
            if(tweet.replyCount>0){
                replyImageView.image = #imageLiteral(resourceName: "reply_sel_ic")
            }else{
                replyImageView.image = #imageLiteral(resourceName: "reply_ic")
            }
            
            senderThumbImageView.layer.cornerRadius = 10.0
            senderThumbImageView.layer.masksToBounds = true
            
            
            if(tweet.retweetUserName != nil){
                retweeterNameLabe.isHidden = false
                retweeterIconImageView.isHidden = false
                retweeterNameLabe.text = tweet.retweetUserName! + (" retweeted")
                thumbImageTopViewConstraint.constant = 5
                fullNameTopViewConstraint.constant = 10
                timeLabelTopViewConstraint.constant = 20
                screenNameLabelTopViewConstraint.constant = 20
            }else{
                retweeterNameLabe.isHidden = true
                retweeterIconImageView.isHidden = true
                thumbImageTopViewConstraint.constant = -17
                fullNameTopViewConstraint.constant = -12
                timeLabelTopViewConstraint.constant = 2
                screenNameLabelTopViewConstraint.constant = 2
            }

        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        print("Comes here ")
        
        let thumbImageTappedGesture = UITapGestureRecognizer(target: self, action: #selector(thumbImagetapped))
        self.senderThumbImageView.addGestureRecognizer(thumbImageTappedGesture)
        self.senderThumbImageView.isUserInteractionEnabled = true
        // Initialization code
    }

    func thumbImagetapped() {
        tweetCellDelegate?.thumbImageTappedAction(senderCell: self)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
