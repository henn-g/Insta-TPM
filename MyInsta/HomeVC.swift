//
//  HomeVC.swift
//  MyInsta
//
//  Created by Henry Guerra on 2/11/19.
//  Copyright © 2019 Henry Guerra. All rights reserved.
//

import UIKit
import Parse
import MBProgressHUD

class HomeVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTableViewCell", for: indexPath) as! HomeTableViewCell
        cell.post = HomeVC.postsArray[indexPath.section]
        
        cell.postImageView.loadInBackground()
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return HomeVC.postsArray.count
    }
    
    // Public outlets
    @IBOutlet weak var tableView: UITableView!
    
    // Public instance vars
    let refreshControl = UIRefreshControl()
    static var postsArray: [Post] = []
    
    // Public Actions
    @IBAction func logoutButton(_ sender: Any) {
        PFUser.logOutInBackground()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 400
        
        // refresh control
       // refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        tableView.insertSubview(refreshControl, at: 0)

        performQuery()
    }
    
    
    // PRIVATE HELPERS
    private func performQuery() {
        let query = PFQuery(className: "Post")
        query.addDescendingOrder("createdAt")
        query.limit = 20
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        query.findObjectsInBackground { (posts: [PFObject]?, error: Error?) -> Void in
            MBProgressHUD.hide(for: self.view, animated: true)
            if posts != nil {
                HomeVC.postsArray = posts as! [Post]
                print(HomeVC.postsArray)
            } else {
                print(error?.localizedDescription as Any)
            }
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
        }
    }

}
