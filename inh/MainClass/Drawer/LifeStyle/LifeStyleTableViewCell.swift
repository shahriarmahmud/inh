//
//  LifeStyleTableViewCell.swift
//  inh
//
//  Created by Priom on 9/17/17.
//  Copyright © 2017 BizTech. All rights reserved.
//

import UIKit

class LifeStyleTableViewCell: UITableViewCell {
    
    @IBOutlet weak var headImage: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var titleHeadImage: UIImageView!
    @IBOutlet weak var headTitleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
