//
//  HamburgerViewController.swift
//  TwitterClient
//
//  Created by Sethi, Pinkesh on 4/21/17.
//  Copyright © 2017 Sethi, Pinkesh. All rights reserved.
//

import UIKit

class HamburgerViewController: UIViewController {
    
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var contentViewLeftConstraint: NSLayoutConstraint!
    var originalLeftConstraint: CGFloat?
    
    var menuViewController: UIViewController!{
        didSet{
            view.layoutIfNeeded()
            let navController = UINavigationController(rootViewController: menuViewController)
            menuView.addSubview(navController.view)
        }
    }
    
    var contentViewController: UIViewController! {
        didSet(oldContentViewController) {
            view.layoutIfNeeded()
            
            if oldContentViewController != nil {
                oldContentViewController.willMove(toParentViewController: nil)
                oldContentViewController.view.removeFromSuperview()
                oldContentViewController.didMove(toParentViewController: nil)
            }
            
            // the following statement will call ViewWillAppear
            contentViewController.willMove(toParentViewController: self)
            let navController = UINavigationController(rootViewController: contentViewController)
            contentView.addSubview(navController.view)
            
            contentViewController.didMove(toParentViewController: self)
            
            UIView.animate(withDuration: 0.3) {
                self.contentViewLeftConstraint.constant = 0
                self.view.layoutIfNeeded()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = UIRectEdge.init(rawValue: 0)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func onPanAction(_ sender: UIPanGestureRecognizer) {
        let transaltion = sender.translation(in: view)
        let velocity = sender.velocity(in: view)
        
        if sender.state == UIGestureRecognizerState.began{
            originalLeftConstraint = contentViewLeftConstraint.constant
            
        } else if sender.state == UIGestureRecognizerState.changed{
            UIView.animate(withDuration: 0.3, animations: {
                self.contentViewLeftConstraint.constant = self.originalLeftConstraint! + transaltion.x
            })
            
        } else if sender.state == UIGestureRecognizerState.ended{
            UIView.animate(withDuration: 0.3, animations: {
                if velocity.x > 0 {
                    self.contentViewLeftConstraint.constant = self.view.frame.size.width - 200
                }else{
                    self.contentViewLeftConstraint.constant = 0
                }
                self.view.layoutIfNeeded()
            })
        }
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
