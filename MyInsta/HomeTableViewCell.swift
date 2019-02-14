//
//  HomeTableViewCell.swift
//  MyInsta
//
//  Created by Henry Guerra on 2/11/19.
//  Copyright © 2019 Henry Guerra. All rights reserved.
//

import UIKit
import Parse
import Parse

class HomeTableViewCell: UITableViewCell {

    // Public Outlets
    @IBOutlet weak var postCaptionLabel: UILabel!
    
    @IBOutlet weak var postImageView: PFImageView!
    
    var post: Post! {
        didSet {
            self.postCaptionLabel.text = post.caption
            self.postImageView.file = post.media as PFFileObject
            self.postImageView.loadInBackground()
           
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
