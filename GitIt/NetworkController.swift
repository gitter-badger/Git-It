//
//  NetworkController.swift
//  GitIt
//
//  Created by Jacob Hawken on 10/20/14.
//  Copyright (c) 2014 Jacob Hawken. All rights reserved.
//

import Foundation

class NetworkController
{
    let operationQueue = NSOperationQueue()
    let urlString = "http://localhost:3000"
    
    init ()
    {
        self.operationQueue.maxConcurrentOperationCount = 10
    }
    
    class var sharedInstance: NetworkController
    {
        struct Static
        {
            static let instance = NetworkController()
        }
        return Static.instance
    }
    
    func repositorySearch (userInput: String, completionHandler : (repoResults: [RepoSummary]?) -> (Void))
    {
        let searchString = userInput.stringByReplacingOccurrencesOfString(" ", withString: "+", options: NSStringCompareOptions.LiteralSearch, range: nil)
        let searchURLString = self.urlString + "/search/repositories?q=" + searchString
        let searchURL = NSURL(string: searchURLString)
        
        let dataTask = NSURLSession.sharedSession().dataTaskWithURL(searchURL, completionHandler:
        { (data, response, error) -> Void in
            var err: NSError?
            
            var jsonResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &err) as NSDictionary
            
            if err != nil
            {
                println("JSON Error \(err!.localizedDescription)")
            }
            
            var repoResult = NSArray()
            
            if let arrayFromJson = jsonResult["items"] as? NSArray
            {
                repoResult = NSArray(array: arrayFromJson)
            }
            else
            {
                println("No matches!")
            }
            
            let repoResults = RepoSummary.parseArrayIntoRepoSummaries(repoResult)
            
            NSOperationQueue.mainQueue().addOperationWithBlock(
            { () -> Void in
                completionHandler(repoResults: repoResults)
            })
        })
        dataTask.resume()
    }
}