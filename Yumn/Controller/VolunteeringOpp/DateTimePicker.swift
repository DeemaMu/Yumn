//
//  DateTimePicker.swift
//  Yumn
//
//  Created by Deema Almutairi on 18/03/2022.
//

import UIKit

class DateTimePicker: NSObject, UIPickerViewDelegate, UIPickerViewDataSource {
    
    // Reference from https://stackoverflow.com/questions/40878547/is-it-possible-to-have-uidatepicker-work-with-start-and-end-time
    
    var didSelectDates: ((_ start: Date, _ end: Date) -> Void)?
    
    private lazy var pickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        return pickerView
    }()
    
    private var days = [Date]()
    
    private var startDate = [Date]()
    private var endDate = [Date]()
    
    let dayFormatter = DateFormatter()
    
    
    var inputView: UIView {
        return pickerView
    }
    
    func setup() {
        dayFormatter.dateFormat = "EE d MMM"
        startDate = setStartDate()
        endDate = setEndDate()
    }
    
    // MARK: - UIPickerViewDelegate & DateSource
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return startDate.count
        case 1:
            return endDate.count
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var label: UILabel
        
        if let view = view as? UILabel {
            label = view
        } else {
            label = UILabel()
        }
        
        label.textColor = .black
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 15)
        
        var text = ""
        
        switch component {
        case 0:
            text = getDayString(from: startDate[row])
        case 1:
            text = getDayString(from: endDate[row])
        default:
            break
        }
        
        label.text = text
        
        return label
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        let startDateIndex = pickerView.selectedRow(inComponent: 0)
        let endDateIndex = pickerView.selectedRow(inComponent: 1)
        
        guard startDate.indices.contains(startDateIndex),
              endDate.indices.contains(endDateIndex) else { return }
        
        let startDate = startDate[startDateIndex]
        let endDate = endDate[endDateIndex]
        
        didSelectDates?(startDate, endDate)
    }
    
    // MARK: - Private helpers
    
    private func getDays(of date: Date) -> [Date] {
        var dates = [Date]()
        
        let calendar = Calendar.current
        
        // first date
        var currentDate = date
        
        // adding 90 days to current date
        let threeMonthsFromNow = calendar.date(byAdding: .day, value: 90, to: currentDate)
        
        // last date
        let endDate = threeMonthsFromNow
        
        while currentDate <= endDate! {
            dates.append(currentDate)
            currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate)!
        }
        
        return dates
    }
    private func getEndDate(of date: Date) -> [Date] {
        var dates = [Date]()
        
        let calendar = Calendar.current
        
        // first date
        var currentDate = date
        
        // adding 90 days to current date
        let threeMonthsFromNow = calendar.date(byAdding: .day, value: 90, to: currentDate)
        
        // last date
        let endDate = threeMonthsFromNow
        
        while currentDate <= endDate! {
            dates.append(currentDate)
            currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate)!
        }
        
        return dates
    }
    
    
    private func setStartDate() -> [Date] {
        let today = Date()
        return getDays(of: today)
    }
    private func setEndDate() -> [Date] {
        let startDateIndex = pickerView.selectedRow(inComponent: 0)
        let startDate = startDate[startDateIndex]
        return getDays(of: startDate)
    }
    private func getDayString(from: Date) -> String {
        return dayFormatter.string(from: from)
    }
    
}

extension Date {
    
    static func buildTimeRangeString(startDate: Date, endDate: Date) -> String {
        
        let startDateFormatter = DateFormatter()
        startDateFormatter.dateFormat = "MMM d, yyyy"
        
        let endDateFormatter = DateFormatter()
        endDateFormatter.dateFormat = "MMM d, yyyy"
        
        return String(format: "%@ - %@",
                      startDateFormatter.string(from: startDate),
                      endDateFormatter.string(from: endDate))
    }
}
