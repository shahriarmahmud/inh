//
//  SectionNewsTableViewCell.swift
//  inh
//
//  Created by Priom on 9/13/17.
//  Copyright © 2017 BizTech. All rights reserved.
//

import UIKit

class SectionNewsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleImage: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!

    @IBOutlet weak var postingTimeLabel: UILabel!
    @IBOutlet weak var thumbnailLabel: UILabel!
    @IBOutlet weak var thumbnailImage: UIImageView!
    
    @IBOutlet weak var SectionTitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
