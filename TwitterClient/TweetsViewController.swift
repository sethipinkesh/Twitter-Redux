//
//  TweetsViewController.swift
//  TwitterClient
//
//  Created by Sethi, Pinkesh on 4/15/17.
//  Copyright © 2017 Sethi, Pinkesh. All rights reserved.
//

import UIKit
import MBProgressHUD

class TweetsViewController: UIViewController {

    
    @IBOutlet weak var tweetsTabelView: UITableView!
    var tweetsArray = [Tweet]()
    var refreshControl = UIRefreshControl()
    var isMoreDataToLoad = false
    var offset = 20 as Int
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tweetsTabelView.dataSource = self
        tweetsTabelView.delegate = self
        tweetsTabelView.rowHeight = UITableViewAutomaticDimension
        tweetsTabelView.estimatedRowHeight = 150

//        self.navigationController?.navigationBar.barTintColor = UIColor(red: (0.0/255.0), green: (172.0/255.0), blue: (237.0/255.0), alpha: 1.0)
//        self.navigationController?.navigationBar.isTranslucent = false
//        UINavigationBar.appearance().isTranslucent = false
//        
//        UINavigationBar.appearance().barTintColor = UIColor(red: (0.0/255.0), green: (172.0/255.0), blue: (237.0/255.0), alpha: 1.0)
//        
//        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        
        
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_refreshControl:)), for: UIControlEvents.valueChanged)
        tweetsTabelView.insertSubview(refreshControl, at: 0)
        self.loadTweetHomeTimeLine()
        
        // Do any additional setup after loading the view.
    }

    func loadTweetHomeTimeLine(){
        
        TwitterAPIClient.sharedInstance?.fetchHomeTimeLine(count:offset, success: { (tweets: [Tweet]) in
            self.tweetsArray = tweets
            print(self.tweetsArray[0])
            self.tweetsTabelView.reloadData()
            if self.refreshControl.isRefreshing{
                self.refreshControl.endRefreshing()
            }

        }, failure: { (error:Error) in
            print(error.localizedDescription)
            print("Some thing went worng need to show it on UI")
            if self.refreshControl.isRefreshing{
                self.refreshControl.endRefreshing()
            }
        })

    }
    func refreshControlAction(_refreshControl: UIRefreshControl){
        loadTweetHomeTimeLine()
    }

    @IBAction func logoutClick(_ sender: Any) {
        TwitterAPIClient.sharedInstance?.logOut()
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if(segue.identifier == "tweetDetailSegue"){
//            let navigationController = segue.destination as! UINavigationController
            let navigationController = segue.destination as! UINavigationController
            let destinationUIViewController = navigationController.topViewController as! TweetDetailViewController
            let cell = sender as! TweetCell
            let index = tweetsTabelView.indexPath(for: cell)
            destinationUIViewController.tweet = tweetsArray[(index?.row)!]
            
        }else if(segue.identifier == "newTweetSegue"){
            let navigationController = segue.destination as! UINavigationController
            let destinationUIViewController = navigationController.topViewController as! AddNewTweetViewController
            destinationUIViewController.delegate = self
        }
    }
}

extension TweetsViewController: UITableViewDelegate, UITableViewDataSource, TweetCellDelegate{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell",for: indexPath) as! TweetCell
        let tweet = tweetsArray[indexPath.row]
        cell.tweet = tweet
        cell.tweetCellDelegate = self
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
    
    func thumbImageTappedAction(senderCell: TweetCell) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let viewController =
            storyBoard.instantiateViewController(withIdentifier:"TimelineViewController") as! TimelineViewController
        viewController.user = senderCell.tweet.user
        let navController = UINavigationController(rootViewController: viewController)
        self.present(navController, animated: true)

    }
}

extension TweetsViewController: AddNewTweetViewControllerDelegate{
    
    func addNewTweetViewController(addNewTweetViewController: AddNewTweetViewController, getNewTweet tweet: Tweet) {
        tweetsArray.insert(tweet, at: 0)
        tweetsTabelView.reloadData()
    }
}

extension TweetsViewController: UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if(!isMoreDataToLoad){
            // Calculate the position of one screen length before the bottom of the results
            let scrollViewContentHeight = tweetsTabelView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tweetsTabelView.bounds.size.height
            
            // When the user has scrolled past the threshold, start requesting
            if(scrollView.contentOffset.y > scrollOffsetThreshold && tweetsTabelView.isDragging) {
                isMoreDataToLoad = true
                loadMoreDataOnIncrementalRefreshing()
                // ... Code to load more results ...
            }
        }
        
    }
    
    func loadMoreDataOnIncrementalRefreshing() {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        offset += 20
        TwitterAPIClient.sharedInstance?.fetchHomeTimeLine(count:offset, success: { (tweets: [Tweet]) in
            self.tweetsArray = tweets
            self.tweetsTabelView.reloadData()
            if self.refreshControl.isRefreshing{
                self.refreshControl.endRefreshing()
            }
            MBProgressHUD.hide(for: self.view, animated: true)
            self.isMoreDataToLoad = false
        }, failure: { (error:Error) in
            print("Some thing went worng need to show it on UI")
            if self.refreshControl.isRefreshing{
                self.refreshControl.endRefreshing()
            }
            MBProgressHUD.hide(for: self.view, animated: true)
            self.isMoreDataToLoad = false
        })
    
    }
}
