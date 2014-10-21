//
//  RepoSearchViewController.swift
//  GitIt
//
//  Created by Jacob Hawken on 10/20/14.
//  Copyright (c) 2014 Jacob Hawken. All rights reserved.
//

import UIKit

class RepoSearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate
{
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var userInput = "tetris"
    var searchResults : [RepoSummary]?

    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.tableView.registerNib(UINib(nibName: "RepoSearchResultCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "SEARCH_RESULT_CELL")
        NetworkController.sharedInstance.repositorySearch(self.userInput, completionHandler:
        { (repoResults) -> (Void) in
            self.tableView.dataSource = self
            self.searchResults = repoResults
            self.tableView.reloadData()
        })
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.searchResults!.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("SEARCH_RESULT_CELL", forIndexPath: indexPath) as RepoSearchResultCell
        
        var repo = self.searchResults![indexPath.row] as RepoSummary
        
        cell.repoName.text = repo.repoName
        cell.userName.text = repo.userName
        
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
