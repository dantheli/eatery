//
//  LookAheadViewController.swift
//  Eatery
//
//  Created by Annie Cheng on 11/28/15.
//  Copyright © 2015 CUAppDev. All rights reserved.
//

import UIKit
import SwiftyJSON
import DiningStack

class LookAheadViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, FilterEateriesViewDelegate, EateryHeaderCellDelegate, FilterDateViewDelegate {

    private var tableView: UITableView!
    private var sectionHeaderHeight: CGFloat = 40.0
    private var eateryHeaderHeight: CGFloat = 55.0
    private var filterSectionHeight: CGFloat = 130.0
    private var filterEateriesCell: FilterEateriesTableViewCell!
    private var filterMealButtons: [UIButton]!
    private var filterDateViews: [FilterDateView]!
    private var selectedMealIndex: Int = 0
    private var selectedDateIndex: Int = 0
    private var sections: [Area] = [.West, .North, .Central]
    private var westEateries: [Eatery] = []
    private var northEateries: [Eatery] = []
    private var centralEateries: [Eatery] = []
    private var selectedMenu: String?
    private var events: [String: Event] = [:]
    private var dates: NSMutableArray {
        let currentDates: NSMutableArray = []
        var currentDate = NSDate()
        
        for var i = 0; i < 7; i++ {
            currentDates.addObject(currentDate)
            let nextDate = NSCalendar.currentCalendar().dateByAddingUnit(.Day, value: 1, toDate: currentDate, options: NSCalendarOptions(rawValue: 0))
            currentDate = nextDate!
        }
        
        return currentDates
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // View appearance
        title = "Eatery Guide"
        edgesForExtendedLayout = .None
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
        tableView.rowHeight = eateryHeaderHeight
        tableView.estimatedRowHeight = UITableViewAutomaticDimension
        view.addSubview(tableView)
    
        // Table View Nibs
        tableView.registerNib(UINib(nibName: "TitleSectionTableViewCell", bundle: nil), forCellReuseIdentifier: "TitleSectionCell")
        tableView.registerNib(UINib(nibName: "FilterEateriesTableViewCell", bundle: nil), forCellReuseIdentifier: "FilterEateriesCell")
        tableView.registerNib(UINib(nibName: "EateryHeaderTableViewCell", bundle: nil), forCellReuseIdentifier: "EateryHeaderCell")
        tableView.registerNib(UINib(nibName: "EateryMenuTableViewCell", bundle: nil), forCellReuseIdentifier: "EateryMenuCell")
        
        // Filter Eateries Header View
        let dayStrings = getDayStrings(dates)
        let dateStrings = getDateStrings(dates)
        let headerView = UIView(frame: CGRectMake(0, 0, view.frame.size.width, filterSectionHeight))
        filterEateriesCell = tableView.dequeueReusableCellWithIdentifier("FilterEateriesCell") as! FilterEateriesTableViewCell
        filterMealButtons = [filterEateriesCell.filterBreakfastButton, filterEateriesCell.filterLunchButton, filterEateriesCell.filterDinnerButton]
        filterDateViews = [filterEateriesCell.firstDateView, filterEateriesCell.secondDateView, filterEateriesCell.thirdDateView, filterEateriesCell.fourthDateView, filterEateriesCell.fifthDateView, filterEateriesCell.sixthDateView, filterEateriesCell.seventhDateView]
        filterEateriesCell.delegate = self
        filterEateriesCell.frame = headerView.frame
        headerView.addSubview(filterEateriesCell)
        tableView.tableHeaderView = headerView
        
        for (index,dateView) in filterDateViews.enumerate() {
            dateView.delegate = self
            dateView.dateButton.tag = index
            dateView.dayLabel.text = dayStrings[index] as? String
            dateView.dateLabel.text = dateStrings[index] as? String
        }
        
        filterDate(filterDateViews)
        filterMeal(filterMealButtons)
        
        // Fetch Eateries Data
        DATA.fetchEateries(false) { (error) -> (Void) in
            dispatch_async(dispatch_get_main_queue(), { [unowned self] () -> Void in
                let eateries = DATA.eateries
                for eatery in eateries {
                    // TODO: Use this part when EateryType is added to DataManager
//                    if eatery.eateryType == .Dining {
//                        switch(eatery.area) {
//                        case .West: self.westEateries.append(eatery)
//                        case .North: self.northEateries.append(eatery)
//                        case .Central: self.centralEateries.append(eatery)
//                        default: break
//                        }
//                    }
                    switch(eatery.area) {
                    case .West: self.westEateries.append(eatery)
                    case .North: self.northEateries.append(eatery)
                    case .Central: self.centralEateries.append(eatery)
                    default: break
                    }
                }
                self.tableView.reloadData()
                })
        }
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
        return sections.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch(sections[section]) {
        case .West: return westEateries.count
        case .North: return northEateries.count
        case .Central: return centralEateries.count
        default: return 1
        }
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return sectionHeaderHeight
        }
        
        return sectionHeaderHeight/2.0
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return eateryHeaderHeight
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCellWithIdentifier("TitleSectionCell") as! TitleSectionTableViewCell

        switch(sections[section]) {
        case .West: cell.titleLabel.text = "WEST CAMPUS EATERIES"
        case .North: cell.titleLabel.text = "NORTH CAMPUS EATERIES"
        case .Central: cell.titleLabel.text = "CENTRAL CAMPUS EATERIES"
        default: break
        }

        return cell
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("EateryHeaderCell") as! EateryHeaderTableViewCell
        var eatery: Eatery!
        let now = NSDate()
        
        switch(sections[indexPath.section]) {
        case .West: eatery = westEateries[indexPath.row]
        case .North: eatery = northEateries[indexPath.row]
        case .Central: eatery = centralEateries[indexPath.row]
        default: break
        }
        
        cell.delegate = self
        cell.eatery = eatery
        cell.eateryNameLabel.text = eatery.nameShort
        cell.eateryHoursLabel.text = "Closed"
        cell.eateryHoursLabel.textColor = UIColor.closedRed()
        
        if let nextEvent = eatery.activeEventForDate(now) {
            cell.eateryHoursLabel.text = displayTextForEvent(nextEvent)
            cell.eateryHoursLabel.textColor = nextEvent.occurringOnDate(now) ? UIColor.openGreen() : UIColor.openYellow()
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        tableView.layoutMargins = UIEdgeInsetsZero
        tableView.separatorInset = UIEdgeInsetsZero
        cell.layoutMargins = UIEdgeInsetsZero
    }
    
    // Eatery Header Cell Delegate Methods
    
    func didTapInfoButton(cell: EateryHeaderTableViewCell?) {
        let indexPath = tableView.indexPathForCell(cell!)
        var eatery: Eatery!
        
        switch(sections[indexPath!.section]) {
        case .West: eatery = westEateries[indexPath!.row]
        case .North: eatery = northEateries[indexPath!.row]
        case .Central: eatery = centralEateries[indexPath!.row]
        default: break
        }
        
        let detailViewController = EatNowDetailViewController()
        detailViewController.eatery = eatery
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }
    
    func didTapToggleMenuButton(cell: EateryHeaderTableViewCell?) {
        // show and hide menu
    }
    
    // Filter Eateries Cell Delegate Methods
    
    func didFilterDate(sender: UIButton?) {
        selectedDateIndex = sender!.tag
        filterDate(filterDateViews)
        tableView.reloadData()
    }
    
    func didFilterMeal(sender: UIButton?) {
        selectedMealIndex = sender!.tag
        filterMeal(filterMealButtons)
        tableView.reloadData()
    }
    
    func filterDate(dateViews: [FilterDateView!]) {
        for dateView in dateViews {
            dateView.dayLabel.font = UIFont(name: "HelveticaNeue-Medium", size: 12.0)
            dateView.dateLabel.font = UIFont(name: "HelveticaNeue-Medium", size: 28.0)
            let button = dateView.dateButton
            
            if button.tag == selectedDateIndex {
                dateView.dayLabel.textColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.7)
                dateView.dateLabel.textColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.7)
            } else {
                dateView.dayLabel.textColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.3)
                dateView.dateLabel.textColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.3)
            }
            
        }
    }
    
    func filterMeal(buttons: [UIButton!]) {
        for button in buttons {
            button.titleLabel!.font = UIFont(name: "HelveticaNeue-Medium", size: 15.0)
            if button.tag == selectedMealIndex {
                button.setTitleColor(UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.7), forState: .Normal)
            } else {
                button.setTitleColor(UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.3), forState: .Normal)
            }
        }
    }

}
