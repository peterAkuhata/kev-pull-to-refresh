//
//  TradeMeTableViewController.swift
//  kev
//
//  Created by Peter Akuhata on 23/06/15.
//  Copyright (c) 2015 Peter Akuhata. All rights reserved.
//

import UIKit

class TradeMeTableViewController: UITableViewController {

    let cellIdentifier: String = "cellIdentifier"
    
    var kevView: KevView!
    var shouldUpdateAnimationTime = false
    
    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl!.tintColor = UIColor.clearColor()
        self.refreshControl!.addTarget(self, action:"startRefreshing", forControlEvents: UIControlEvents.ValueChanged)

        self.kevView = KevView(frame: self.refreshControl!.bounds)
        self.kevView.contentMode = UIViewContentMode.ScaleAspectFit
        self.refreshControl!.addSubview(kevView);

        self.tableView.addSubview(self.refreshControl!)
    }

    // MARK: - UIScrollView
    
    override func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        if !refreshControl!.refreshing {
            kevView.removeAllAnimations()
            kevView.addFadeInAnimation()
            kevView.layer.beginTime = CACurrentMediaTime()
            kevView.layer.speed = 0.0
            shouldUpdateAnimationTime = true
        }
    }
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        if let refresher = refreshControl {
            NSLog("refresherFrame=\(NSStringFromCGRect(refresher.frame))")
            let pullAmount = max(0.0, -refresher.frame.origin.y - 30.0)
            let ratio = pullAmount / 130
            
            if shouldUpdateAnimationTime && pullAmount > 0.0 {
                kevView.layer.timeOffset = Double(3.0 * ratio)
            }
        }
    }
    
    // MARK: - Utility methods
    
    func startRefreshing() {
        shouldUpdateAnimationTime = false
        kevView.removeFadeInAnimation()
        kevView.addWalkingAnimation()
        kevView.layer.speed = 1.0
        kevView.layer.timeOffset = 0.0
        kevView.layer.beginTime = CACurrentMediaTime()

        // make a call to update the information in the table view after which we end refreshing
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(2 * NSEC_PER_SEC)), dispatch_get_main_queue()) {
            if let refresher = self.refreshControl {
                self.tableView.reloadData()
                self.kevView.addFadeOutAnimation({ (Bool finished) -> Void in
                    self.kevView.removeAllAnimations()
                })
                refresher.endRefreshing()
            }
        }
    }
    
    // MARK: - UITableViewDatasource

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! UITableViewCell
        
        cell.textLabel?.text = "\(indexPath.row)"
        
        return cell
    }
}
