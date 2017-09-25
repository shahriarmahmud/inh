//
//  VideosTableViewCell.swift
//  inh
//
//  Created by Shahriar Mahmud on 9/20/17.
//  Copyright © 2017 BizTech. All rights reserved.
//

import UIKit

class VideosTableViewCell: UITableViewCell {
    
    @IBOutlet weak var headImage: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var headLineImage: UIImageView!
    @IBOutlet weak var HeadLineTitle: UILabel!

    @IBOutlet weak var videoImage: UIImageView!
    @IBOutlet weak var videosImage_title: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
