//
//  EateryMenuTableViewCell.swift
//  Eatery
//
//  Created by Annie Cheng on 11/28/15.
//  Copyright © 2015 CUAppDev. All rights reserved.
//

import UIKit

class EateryMenuTableViewCell: UITableViewCell {
    
    @IBOutlet weak var eateryMenuLabel: UILabel!
    @IBOutlet weak var shareMenuButton: UIButton!
    @IBOutlet weak var menuImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .None
    }

}
