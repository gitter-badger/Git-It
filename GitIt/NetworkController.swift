//
//  NetworkController.swift
//  GitIt
//
//  Created by Jacob Hawken on 10/20/14.
//  Copyright (c) 2014 Jacob Hawken. All rights reserved.
//

import Foundation
import UIKit

class NetworkController
{
    let operationQueue = NSOperationQueue()
    let apiURL = "https://api.github.com"
    let clientID = "client_id=0d2e928270ed3a30ccbf"
    let clientSecret = "client_secret=93395912132d408c5394316635ad56c20c1c8710"
    let githubOAuthURL = "https://github.com/login/oauth/authorize?"
    let scope = "scope=user,repo"
    let redirectURL = "redirect_uri=gitit://test"
    let githubPOSTURL = "https://github.com/login/oauth/access_token"
    var session = NSURLSession()
    var token : String?
    
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
    
    func requestOAuthAccess() //out of the app to github site for authorization
    {
        let url = self.githubOAuthURL + self.clientID + "&" + self.redirectURL + "&" + self.scope
        UIApplication.sharedApplication().openURL(NSURL(string: url))
    }
    
    func handleOAuthURL(callbackURL : NSURL)
    {
        let query = callbackURL.query
        let components = query?.componentsSeparatedByString("code=") //evaluates to an array, thus the next line
        let code = components?.last
        println(code)
        
        let urlQuery = clientID + "&" + clientSecret + "&" + "code=\(code!)"
        
        var request = NSMutableURLRequest(URL: NSURL(string: githubPOSTURL))
        request.HTTPMethod = "POST"
        
        var postData = urlQuery.dataUsingEncoding(NSASCIIStringEncoding, allowLossyConversion: true)
        let length = postData!.length
        request.setValue("\(length)", forHTTPHeaderField: "Content-Length")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = postData
        
        var dataTask = NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler:
        { (data, response, error) -> Void in
            if error != nil
            {
                println(error.localizedDescription)
            }
            else
            {
                if let httpResponse = response as? NSHTTPURLResponse
                {
                    switch httpResponse.statusCode
                    {
                    case 200...204:
                        var tokenResponse = NSString(data: data, encoding: NSASCIIStringEncoding)
                        println(tokenResponse)
                        
                        let tokenFirstPass = tokenResponse.componentsSeparatedByString("=")
                        let protoToken = tokenFirstPass[1] as String
                        let tokenSecondPass = protoToken.componentsSeparatedByString("&")
                        self.token = tokenSecondPass[0]
                        println("The token is: \(self.token)")
                        
                        var configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
                        var myHTTPAdditionalHeaders : [NSObject : AnyObject] = ["Authorization" : "token OAUTH-TOKEN"]
                        configuration.HTTPAdditionalHeaders = myHTTPAdditionalHeaders
                        self.session = NSURLSession(configuration: configuration)
                        
                        NSOperationQueue.mainQueue().addOperationWithBlock(
                        { () -> Void in
                            
                        })
                    default:
                        println("Default case on status code")
                    }
                }
            }
            let tokenKey = "token"
            NSUserDefaults.standardUserDefaults().setObject(self.token, forKey: tokenKey)
            NSUserDefaults.standardUserDefaults().synchronize()
        })
        dataTask.resume()
    }
    
    //sends a search query and returns an array of repo summary objects
    func repositorySearch (userInput: String, completionHandler : (repoResults: [RepoSummary]?) -> (Void))
    {
        let searchString = userInput.stringByReplacingOccurrencesOfString(" ", withString: "+", options: NSStringCompareOptions.LiteralSearch, range: nil)
        let searchURLString = self.apiURL + "/search/repositories?q=" + searchString
        let searchURL = NSURL(string: searchURLString)
        
        let dataTask = self.session.dataTaskWithURL(searchURL, completionHandler:
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