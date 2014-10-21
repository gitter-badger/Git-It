//
//  SplitViewController.swift
//  GitIt
//
//  Created by Jacob Hawken on 10/20/14.
//  Copyright (c) 2014 Jacob Hawken. All rights reserved.
//

import UIKit

class SplitViewContainerController: UIViewController, UISplitViewControllerDelegate
{

    override func viewDidLoad()
    {
        super.viewDidLoad()

        let splitVC = self.childViewControllers[0] as UISplitViewController
        splitVC.delegate = self
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    func splitViewController(splitViewController: UISplitViewController, collapseSecondaryViewController secondaryViewController: UIViewController!, ontoPrimaryViewController primaryViewController: UIViewController!) -> Bool {
        return true
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
