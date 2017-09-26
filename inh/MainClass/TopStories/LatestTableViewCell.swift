//
//  LatestTableViewCell.swift
//  inh
//
//  Created by Shahriar Mahmud on 9/13/17.
//  Copyright © 2017 BizTech. All rights reserved.
//

import UIKit

class LatestTableViewCell: UITableViewCell {
    
    @IBOutlet weak var customSeparator: UIView!
    @IBOutlet weak var videoImage: UIImageView!
    @IBOutlet weak var headerImage: UIImageView!

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
