//
//  LookAheadViewController.swift
//  Eatery
//
//  Created by Annie Cheng on 11/28/15.
//  Copyright © 2015 CUAppDev. All rights reserved.
//

import UIKit
import DiningStack

class LookAheadViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, FilterEateriesViewDelegate, EateryHeaderCellDelegate, FilterDateViewDelegate {

    var sectionTitles: [String] = ["VIEW MENUS AND HOURS FOR AN UPCOMING TIME", "WEST CAMPUS EATERIES", "NORTH CAMPUS EATERIES"]
    var filteredEateries: [String] = ["Becker House Dining Room", "Bethe House Dining Room", "Cook House Dining Room", "Rose House Dining Room", "Keeton House Dining Room"]
    var dates: NSMutableArray {
        let currentDates: NSMutableArray = []
        var currentDate = NSDate()
        
        for var i = 0; i < 7; i++ {
            currentDates.addObject(currentDate)
            let nextDate = NSCalendar.currentCalendar().dateByAddingUnit(.Day, value: 1, toDate: currentDate, options: NSCalendarOptions(rawValue: 0))
            currentDate = nextDate!
        }
        
        return currentDates
    }
    
    var tableView: UITableView!
    var sectionHeaderHeight: CGFloat = 40.0
    var eateryHeaderHeight: CGFloat = 55.0
    var filterSectionHeight: CGFloat = 90.0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // View appearance
        title = "Eatery Guide"
        view.backgroundColor = UIColor.groupTableViewBackgroundColor()
        
        // Navigation Controller
        navigationController?.view.backgroundColor = UIColor.whiteColor()
        navigationController?.navigationBar.translucent = false
        navigationController?.navigationBar.barTintColor = UIColor.eateryBlue()
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "Avenir Next", size: 20)!]
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        // Table View
        let tableViewFrame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        tableView = UITableView(frame: tableViewFrame, style: .Grouped)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorInset = UIEdgeInsetsZero
        tableView.rowHeight = eateryHeaderHeight
        tableView.estimatedRowHeight = UITableViewAutomaticDimension
        view.addSubview(tableView)
        
        // Table View Nibs
        tableView.registerNib(UINib(nibName: "TitleSectionTableViewCell", bundle: nil), forCellReuseIdentifier: "TitleSectionCell")
        tableView.registerNib(UINib(nibName: "FilterEateriesTableViewCell", bundle: nil), forCellReuseIdentifier: "FilterEateriesCell")
        tableView.registerNib(UINib(nibName: "EateryHeaderTableViewCell", bundle: nil), forCellReuseIdentifier: "EateryHeaderCell")
        tableView.registerNib(UINib(nibName: "EateryMenuTableViewCell", bundle: nil), forCellReuseIdentifier: "EateryMenuCell")
    }
    
    // Date Methods
    
    func getDayStrings(dates: NSMutableArray) -> NSMutableArray {
        let dayStrings: NSMutableArray = ["Today"]
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "EEE"
        dates.removeObjectAtIndex(0)
        
        for date in dates {
            dayStrings.addObject(dateFormatter.stringFromDate(date as! NSDate))
        }
        
        return dayStrings
    }
    
    func getDateStrings(dates: NSMutableArray) -> NSMutableArray {
        let dateStrings: NSMutableArray = []
        let calendar = NSCalendar.currentCalendar()
        
        for date in dates {
            let dayComponents = calendar.component(.Day, fromDate: date as! NSDate)
            dateStrings.addObject(String(dayComponents))
        }
        
        return dateStrings
    }
    
    // Table View Methods
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        
        return filteredEateries.count
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return sectionHeaderHeight
        }
        
        return sectionHeaderHeight/2.0
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return filterSectionHeight
        }
        
        return eateryHeaderHeight
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCellWithIdentifier("TitleSectionCell") as! TitleSectionTableViewCell
        
        cell.titleLabel.text = sectionTitles[section]
        
        return cell
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("FilterEateriesCell") as! FilterEateriesTableViewCell
            let dateViews = [cell.firstDateView, cell.secondDateView, cell.thirdDateView, cell.fourthDateView, cell.fifthDateView, cell.sixthDateView, cell.seventhDateView]
            let dayStrings = getDayStrings(dates)
            let dateStrings = getDateStrings(dates)
            
            for (index,dateView) in dateViews.enumerate() {
                dateView.delegate = self
                dateView.dateButton.tag = index
                dateView.dayLabel.text = dayStrings[index] as? String
                dateView.dateLabel.text = dateStrings[index] as? String
            }
            
            cell.delegate = self
            
            return cell
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier("EateryHeaderCell") as! EateryHeaderTableViewCell
        
        cell.delegate = self
        cell.eateryNameLabel.text = filteredEateries[indexPath.row]
        cell.eateryHoursLabel.text = "Open 5 PM to 8 PM"
        
        return cell
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        tableView.layoutMargins = UIEdgeInsetsZero
        tableView.separatorInset = UIEdgeInsetsZero
        cell.layoutMargins = UIEdgeInsetsZero
    }
    
    // Eatery Header Cell Delegate Methods
    
    func didTapInfoButton() {
        // push to detail view controller
    }
    
    func didTapToggleMenuButton() {
        // show and hide menu
    }
    
    // Filter Eateries Cell Delegate Methods
    
    func didFilterDate(sender: UIButton?) {
        switch (sender!.tag) {
        case 0:
            print("date 1")
        case 1:
            print("date 2")
        case 2:
            print("date 3")
        case 3:
            print("date 4")
        case 4:
            print("date 5")
        case 5:
            print("date 6")
        default:
            print("date 7")
        }
    }
    
    func didFilterMeal(sender: UIButton?) {
        switch (sender!.tag) {
        case 0:
            print("breakfast")
        case 1:
            print("lunch")
        default:
            print("dinner")
        }
    }

}
