//
//  User.swift
//  TwitterClient
//
//  Created by Sethi, Pinkesh on 4/15/17.
//  Copyright © 2017 Sethi, Pinkesh. All rights reserved.
//

import UIKit

class User: NSObject {
    
    let currentUserKey = "currentUsetData"
    let UserDidLoginNotification = "UserDidLoginNotification"
    let UserDidLogoutNotification = "UserDidLogoutNotification"
    
    var name: String?
    var profilePhotoUrl: URL?
    var screenName: String?
    var tagLine: String?
    var dictionary: Dictionary<String, Any>
    var profileBannerUrl: URL?
    var id:UInt64?
    
    var tweetCount: Int?
    var followersCount: Int?
    var followingCount: Int?
    

    init(userDataDictionary: Dictionary<String, Any>) {
        self.dictionary = userDataDictionary
        name = userDataDictionary["name"] as? String
        let urlString = userDataDictionary["profile_image_url_https"] as? String
        if let urlStr = urlString{
            profilePhotoUrl = URL(string: urlStr)
        }
        screenName = userDataDictionary["screen_name"] as? String
        tagLine = userDataDictionary["discription"] as? String
        
        let bannerUrlString = userDataDictionary["profile_background_image_url_https"] as? String
        if let bannerUrlString = bannerUrlString{
            profileBannerUrl = URL(string: bannerUrlString)
        }
        
        id = userDataDictionary["id"] as? UInt64
        tweetCount = userDataDictionary["statuses_count"] as? Int
        followersCount = userDataDictionary["followers_count"] as? Int
        followingCount = userDataDictionary["friends_count"] as? Int

        
    }
    
    func logout() {
        User.currentUser = nil
//        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
        
        NotificationCenter.default.post(name: NSNotification.Name(UserDidLogoutNotification), object: nil, userInfo: nil)
    }
    static var _currentUser: User?
    class var currentUser: User? {
        get {
            if _currentUser == nil {
                let defaults = UserDefaults.standard
                let userData = defaults.object(forKey: "currentUserData") as? Data
                if let userData = userData{
                    let dictionary = try! JSONSerialization.jsonObject(with: userData, options: []) as! Dictionary<String, Any>
                    _currentUser = User(userDataDictionary: dictionary)
                }
            }
            return _currentUser
        }
        set(user) {
            _currentUser = user
            if let user = user{
                let data = try! JSONSerialization.data(withJSONObject: user.dictionary, options: .prettyPrinted)
                UserDefaults.standard.set(data, forKey: "currentUserData")
            }else{
                UserDefaults.standard.removeObject(forKey: "currentUserData")
            }
            UserDefaults.standard.synchronize()
        }
    }
}
