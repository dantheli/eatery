//
//  EatNowDetailViewController.swift
//  Eatery
//
//  Created by Eric Appel on 3/19/15.
//  Copyright (c) 2015 CUAppDev. All rights reserved.
//

import UIKit

private let kHeaderViewFrameHeight: CGFloat = 240

class EatNowDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, SegmentChangedDelegate {
    
    var eatery: Eatery!
    private var headerView: EatNowDetailHeaderView!
    private var tableView: UITableView!
    private var mealSegments: [String]!
    private var sectionHeaderView: SegmentedControlSectionHeaderView!
    private var selectedMenu: String?
    private var events: [String: Event] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // View appearance
        view.backgroundColor = UIColor.groupTableViewBackgroundColor()
        
        // Header View
        headerView = NSBundle.mainBundle().loadNibNamed("EatNowDetailHeaderView", owner: self, options: nil).first as! EatNowDetailHeaderView
        headerView.setEatery(eatery)
        headerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: kHeaderViewFrameHeight)
        view.addSubview(headerView)
        
        // Table View
        let statusBarHeight: CGFloat = 20
        let tableViewFrameHeight = view.frame.height - navigationController!.navigationBar.frame.height - statusBarHeight
        let tableViewFrame = CGRect(x: 0, y: 0, width: view.frame.width, height: tableViewFrameHeight)
        tableView = UITableView(frame: tableViewFrame, style: .Plain)
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
        
        let blankView = UIView(frame: headerView.frame)
        blankView.alpha = 0
        tableView.tableHeaderView = blankView
        tableView.backgroundColor = UIColor.clearColor()
        tableView.estimatedRowHeight = 120
        tableView.rowHeight = UITableViewAutomaticDimension
        
        tableView.registerNib(UINib(nibName: "HoursTableViewCell", bundle: nil), forCellReuseIdentifier: "HoursCell")
        tableView.registerNib(UINib(nibName: "MealTableViewCell", bundle: nil), forCellReuseIdentifier: "MealCell")
        
        // DO NOT set the separatorStyle above the -registerNib calls.  It crashes because Xcode is made by interns.
        tableView.separatorStyle = .None
        sectionHeaderView = NSBundle.mainBundle().loadNibNamed("SegmentedControlSectionHeaderView", owner: self, options: nil).first as! SegmentedControlSectionHeaderView
        
        sectionHeaderView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 64)
        sectionHeaderView.delegate = self
        
        // Find array of available meals for a given menu (i.e. Brunch, Dinner)
        let active = eatery.activeEventForDate(NSDate())
        events = eatery.eventsOnDate(active?.startDate ?? NSDate())
        let mealsAvailable: [String] = Array((events ?? [:]).keys)
        selectedMenu = mealsAvailable.first
        
        // Sort them in ascending order (Breakfast < Brunch < Lunch < Dinner)
        var sortedSegments = mealsAvailable
        
        //!TODO: don't hardcode these strings here
        sortedSegments.sortInPlace { (lhs, rhs) -> Bool in
            if lhs == "Breakfast" {
                return true
            }
            if rhs == "Breakfast" {
                return false
            }
            if lhs == "Brunch" {
                return true
            }
            if rhs == "Brunch" {
                return false
            }
            if lhs == "Dinner" {
                return false
            }
            return true
        }
        
        mealSegments = sortedSegments

        // Has 2 segments by default, so we need to adjust for 1, 3 and 4
        let numberOfSegments = mealSegments.count
        if numberOfSegments == 1 {
            sectionHeaderView.segmentedControl.removeSegmentAtIndex(1, animated: false)
        } else if numberOfSegments > 2 {
            let placeholderTitle = "NULL"
            for i in 2..<numberOfSegments {
                sectionHeaderView.segmentedControl.insertSegmentWithTitle(placeholderTitle, atIndex: i, animated: false)
            }
        }
        
        for i in 0..<numberOfSegments {
            let mealString = mealSegments[i]
            // Capitalize first letter of meal
            sectionHeaderView.segmentedControl.setTitle(mealString, forSegmentAtIndex: i)
        }
    
        
        let attributes: [NSObject : AnyObject] = [
            NSFontAttributeName : UIFont(name: "Avenir Next", size: 16)!
        ]
        sectionHeaderView.segmentedControl.setTitleTextAttributes(attributes, forState: .Normal)
        
        Analytics.screenEatNowDetailViewController(eatery.slug)
    }
    
    // Mark: -
    // MARK: UITableViewDataSource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            if let event = events[selectedMenu ?? ""] {
                return event.menu.count
            }
        }
        
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("HoursCell", forIndexPath: indexPath) as! HoursTableViewCell
            cell.selectionStyle = .None

            // If the eatery has zero or just a closed event, display a "closed" cell
            var eateryIsClosed = !eatery.isOpenNow()

            if eateryIsClosed {
                cell.leftLabel.text = "Closed"
                cell.rightLabel.text = ""
                return cell
            }
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("MealCell", forIndexPath: indexPath) as! MealTableViewCell
            cell.selectionStyle = .None
            
            var stationArray: [String] = [] //Array(displayMenu[showingMealTypeString]!.keys)
            
            let title = ""//stationArray[indexPath.row]
            let content = ""//displayMenu[showingMealTypeString]![title]
            
            cell.titleLabel.text = title.uppercaseString
            cell.contentLabel.text = content
            
            return cell
        }
    }
    
    // Mark: -
    // MARK: UITableViewDelegate
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return sectionHeaderView
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1 {
            return 54
        } else {
            return 0
        }
    }
    
    // MARK: -
    // MARK: UIScrollViewDelegate
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        headerView.frame = CGRectMake(0, 0, tableView.frame.width, kHeaderViewFrameHeight - scrollView.contentOffset.y)
    }
    
    // TODO: move this to the time factory and change the method name
    private func dateConverter(date1: NSDate, date2: NSDate) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.timeZone = NSTimeZone(name: "America/New_York")!
        dateFormatter.dateFormat = "h:mm a"
        
        return "\(dateFormatter.stringFromDate(date1)) - \(dateFormatter.stringFromDate(date2))"
    }
    
    // MARK: -
    // MARK: SegmentChangedDelegate
    
    func valueChangedForSegmentedControl(sender: UISegmentedControl) {
        selectedMenu = sender.titleForSegmentAtIndex(sender.selectedSegmentIndex)
        tableView.reloadData()
    }
}






