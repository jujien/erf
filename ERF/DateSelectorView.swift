//
//  DateSelectorView.swift
//  ERF
//
//  Created by Vũ Kiên on 28/07/2016.
//  Copyright © 2016 Kiên Vũ. All rights reserved.
//

import UIKit
import CVCalendar

class DateSelectorView: UIView, CVCalendarViewDelegate, CVCalendarMenuViewDelegate {
    
    @IBOutlet weak var calendarView: CVCalendarView!
    @IBOutlet weak var calendarMenuView: CVCalendarMenuView!

    @IBOutlet weak var submitButton: UIButton!
    
    var time = ""
    var submitFlag = ""
    
    override func awakeFromNib() {
        calendarView.calendarDelegate = self
        calendarMenuView.menuViewDelegate = self
        calendarMenuView.dayOfWeekTextColor = UIColor.whiteColor()
        calendarMenuView.tintColor = UIColor.whiteColor()
    }
    
    override func layoutSubviews() {
        calendarView.commitCalendarViewUpdate()
        calendarMenuView.commitMenuViewUpdate()
        submitButton.layer.cornerRadius = 5.0
    }
    
    @IBAction func submitDidTapped(sender: UIButton) {
        submitFlag = "submit"
        sender.userInteractionEnabled = false
        NSNotificationCenter.defaultCenter().postNotificationName("Date Selector", object: nil, userInfo: ["submitFlag": submitFlag, "time": time])
    }
    
    func presentationMode() -> CalendarMode {
        return CalendarMode.MonthView
    }
    
    func firstWeekday() -> Weekday {
        return Weekday.Monday
    }
    
    func didSelectDayView(dayView: DayView, animationDidFinish: Bool) {
        let day = dayView.date.day
        let month = dayView.date.month
        let year = dayView.date.year
        time = "\(year)-\(month)-\(day)"
        
    }
}
