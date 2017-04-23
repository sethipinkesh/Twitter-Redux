//
//  MentionsViewController.swift
//  TwitterClient
//
//  Created by Sethi, Pinkesh on 4/22/17.
//  Copyright © 2017 Sethi, Pinkesh. All rights reserved.
//

import UIKit

class MentionsViewController: UIViewController {
    @IBOutlet weak var mentionsTableView: UITableView!
    var tweetsArray = [Tweet]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mentionsTableView.dataSource = self
        mentionsTableView.delegate = self
        mentionsTableView.rowHeight = UITableViewAutomaticDimension
        mentionsTableView.estimatedRowHeight = 150
        
        loadMentions()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadMentions(){
        
        TwitterAPIClient.sharedInstance?.mentions(success: { (tweets: [Tweet]) in
            self.tweetsArray = tweets
            print(self.tweetsArray[0])
            self.mentionsTableView.reloadData()
            
            
        }, failure: { (error:Error) in
            print("Some thing went worng need to show it on UI")
        })
        
    }
    @IBAction func onLogoutButtonTap(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension MentionsViewController: UITableViewDataSource,UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetMentionCell",for: indexPath) as! TweetCell
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
