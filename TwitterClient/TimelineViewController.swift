//
//  TimelineViewController.swift
//  TwitterClient
//
//  Created by Sethi, Pinkesh on 4/22/17.
//  Copyright © 2017 Sethi, Pinkesh. All rights reserved.
//

import UIKit

class TimelineViewController: UIViewController {
  
    @IBOutlet weak var timeLineTableView: UITableView!
    var tweetsArray = [Tweet]()
    var user: User?
    var isOtherUser: Bool?
    var headerView: ProfileSectionCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timeLineTableView.dataSource = self
        timeLineTableView.delegate = self
        timeLineTableView.rowHeight = UITableViewAutomaticDimension
        timeLineTableView.estimatedRowHeight = 150
        
        if user == nil{
            isOtherUser = false
            user = User.currentUser
        }else{
            isOtherUser = true
        }
        self.navigationItem.title = user?.name
        if isOtherUser!{
            self.navigationItem.leftBarButtonItem?.title = "Back"
        
        }
        
        loadTimeLineData()
        
        headerView = Bundle.main.loadNibNamed("ProfileSectionCell", owner: self, options: nil)?.first as! ProfileSectionCell
        headerView.user = user
        headerView.layoutIfNeeded()
        timeLineTableView.tableHeaderView = headerView
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func loadTimeLineData(){
        
        TwitterAPIClient.sharedInstance?.userTimeline(id: (user?.id)!, success: { (tweets: [Tweet]) in
            self.tweetsArray = tweets
            print(self.tweetsArray[0])
            self.timeLineTableView.reloadData()
            
        }, failure: { (error:Error) in
            print("Some thing went worng need to show it on UI")
        })
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func onRightNavButtonTap(_ sender: UIBarButtonItem) {
        
    }
   
    @IBAction func onLeftNavtButtontap(_ sender: UIBarButtonItem) {
        if isOtherUser!{
            self.dismiss(animated: true, completion: nil)
        }else{
            TwitterAPIClient.sharedInstance?.logOut()
        }
    }
}

extension TimelineViewController: UITableViewDataSource,UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetTimelineCell",for: indexPath) as! TweetCell
        let tweet = tweetsArray[indexPath.row]
        cell.tweet = tweet
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor(red: (192/255.0), green: (222/255.0), blue: (237/255.0), alpha: 1.0)
        
        cell.selectedBackgroundView = backgroundView
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweetsArray.count
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

extension TimelineViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let offset = scrollView.contentOffset.y
        print(String(describing: offset as CGFloat))
        if offset <= 0 {
            UIView.animate(withDuration: 0.3, animations: {
                self.headerView.profileBannerImageView.transform = CGAffineTransform(scaleX: 1.2, y: 1)
                 self.headerView.profileBannerImageView.alpha = 1
                if(offset == 0){
                    self.headerView.profileBannerImageView.transform = CGAffineTransform.identity
                }
            })
        }else {
            UIView.animate(withDuration: 0.2, animations: {
                self.headerView.profileBannerImageView.transform = CGAffineTransform.identity
                self.headerView.profileBannerImageView.alpha = 0.7
            })
        }
    }
   
    
}

