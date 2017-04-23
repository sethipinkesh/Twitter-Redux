//
//  MenuViewController.swift
//  TwitterClient
//
//  Created by Sethi, Pinkesh on 4/21/17.
//  Copyright © 2017 Sethi, Pinkesh. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {

    @IBOutlet weak var menuTableView: UITableView!
    var viewControllers: [UIViewController] = []
    var hamburgerViewController: HamburgerViewController!
    private var homeTimeLineViewController: UIViewController!
    
    private var timeLineViewController: UIViewController!
    private var mentionsViewController: UIViewController!
    
    let menuItemLabels = ["Profile", "Timeline", "Mentions"]
    override func viewDidLoad() {
        super.viewDidLoad()
        menuTableView.delegate = self
        menuTableView.dataSource = self
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        
        timeLineViewController = storyBoard.instantiateViewController(withIdentifier: "TimelineViewController")
        homeTimeLineViewController = storyBoard.instantiateViewController(withIdentifier: "HomeTimeLineViewController")
        mentionsViewController = storyBoard.instantiateViewController(withIdentifier: "MentionsViewController")
        viewControllers.append(timeLineViewController)
        viewControllers.append(homeTimeLineViewController)
        viewControllers.append(mentionsViewController)
        
        hamburgerViewController.contentViewController = viewControllers[1]
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

extension MenuViewController: UITableViewDataSource, UITableViewDelegate{

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuItemCell", for: indexPath) as! MenuItemCell
        cell.menuItemName.text = menuItemLabels[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewControllers.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.view.frame.height/CGFloat(viewControllers.count)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        hamburgerViewController.contentViewController = viewControllers[indexPath.row]
    }

}
