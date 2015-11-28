//
//  FilterEateriesTableViewCell.swift
//  Eatery
//
//  Created by Annie Cheng on 11/28/15.
//  Copyright © 2015 CUAppDev. All rights reserved.
//

import UIKit

@objc protocol FilterEateriesViewDelegate {
    optional func didFilterMeal(sender: UIButton?)
    optional func didFilterDate(sender: UIButton?)
}

class FilterEateriesTableViewCell: UITableViewCell {

    @IBOutlet weak var firstDateView: FilterDateView!
    @IBOutlet weak var secondDateView: FilterDateView!
    @IBOutlet weak var thirdDateView: FilterDateView!
    @IBOutlet weak var fourthDateView: FilterDateView!
    @IBOutlet weak var fifthDateView: FilterDateView!
    @IBOutlet weak var sixthDateView: FilterDateView!
    @IBOutlet weak var seventhDateView: FilterDateView!
    @IBOutlet weak var filterBreakfastButton: UIButton!
    @IBOutlet weak var filterLunchButton: UIButton!
    @IBOutlet weak var filterDinnerButton: UIButton!
    
    var delegate: FilterEateriesViewDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
        selectionStyle = .None
    }
    
    @IBAction func didFilterMeal(sender: UIButton?) {
        self.delegate?.didFilterMeal!(sender)
    }
    
}
