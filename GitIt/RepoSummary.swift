//
//  RepoSummary.swift
//  GitIt
//
//  Created by Jacob Hawken on 10/20/14.
//  Copyright (c) 2014 Jacob Hawken. All rights reserved.
//

import Foundation

class RepoSummary
{
    var repoName : String?
    var repoURL : NSURL?
    var description : String?
    var forkCount : Int?
    var starCount : Int?
    var watcherCount : Int?
    var userName : String?
    var avatarURL : NSURL?
    
    init (repoInfo : NSDictionary)
    {
        self.repoName = repoInfo["name"] as? String
        let repoURLString = repoInfo["url"] as? String
        self.repoURL = NSURL(string: repoURLString!)
        self.description = repoInfo["description"] as? String
        self.forkCount = repoInfo["forks_count"] as? Int
        self.starCount = repoInfo["stargazers_count"] as? Int
        self.watcherCount = repoInfo["watchers_count"] as? Int
        let userInfo = repoInfo["owner"] as NSDictionary
        self.userName = userInfo["login"] as? String
        let avatarURLString = userInfo["avatar_url"] as String
        self.avatarURL = NSURL(string: avatarURLString)
    }
    
    class func parseArrayIntoRepoSummaries (repoArray: NSArray) -> [RepoSummary]?
    {
        var error : NSError?
        var summaries = [RepoSummary]()
        
        for repoDictionary in repoArray
        {
            if let repoSummaryDictionary = repoDictionary as? NSDictionary
            {
                var newRepoSummary = RepoSummary(repoInfo: repoSummaryDictionary)
                summaries.append(newRepoSummary)
            }
        }
        return summaries
    }
}