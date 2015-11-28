//
//  EateryHeaderTableViewCell.swift
//  Eatery
//
//  Created by Annie Cheng on 11/28/15.
//  Copyright © 2015 CUAppDev. All rights reserved.
//

import UIKit

class EateryHeaderTableViewCell: UITableViewCell {
    
    @IBOutlet weak var eateryNameLabel: UILabel!
    @IBOutlet weak var eateryHoursLabel: UILabel!
    @IBOutlet weak var infoButton: UIButton!
    @IBOutlet weak var toggleMenuButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .None
        infoButton.tintColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.5)
    }
    
}
