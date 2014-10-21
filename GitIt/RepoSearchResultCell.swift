//
//  RepoSearchResultCell.swift
//  GitIt
//
//  Created by Jacob Hawken on 10/20/14.
//  Copyright (c) 2014 Jacob Hawken. All rights reserved.
//

import UIKit

class RepoSearchResultCell: UITableViewCell
{
    @IBOutlet weak var repoName: UILabel!
    @IBOutlet weak var userName: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
