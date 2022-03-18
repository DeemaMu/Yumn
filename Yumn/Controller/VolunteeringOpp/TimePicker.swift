//
//  TimePicker.swift
//  Yumn
//
//  Created by Deema Almutairi on 19/03/2022.
//

import Foundation
import UIKit

class TimePicker: NSObject, UIPickerViewDelegate, UIPickerViewDataSource {


      var didSelectTimes: ((_ start: Date, _ end: Date) -> Void)?
      
      private lazy var pickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        return pickerView
      }()
      
      private var startTimes = [Date]()
      private var endTimes = [Date]()
      
      let dayFormatter = DateFormatter()
      let timeFormatter = DateFormatter()
      
      var inputView: UIView {
        return pickerView
      }
      
      func setup() {
        timeFormatter.timeStyle = .short
        startTimes = setStartTimes()
        endTimes = setEndTimes()
      }
      
      // MARK: - UIPickerViewDelegate & DateSource
      
      func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
      }
      
      func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
          return startTimes.count
        case 1:
          return endTimes.count
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
            text = getTimeString(from: startTimes[row])
        case 1:
          text = getTimeString(from: endTimes[row])
        default:
          break
        }
        
        label.text = text
        
        return label
      }
      
      func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        let startTimeIndex = pickerView.selectedRow(inComponent: 0)
        let endTimeIndex = pickerView.selectedRow(inComponent: 1)
        
        guard startTimes.indices.contains(startTimeIndex),
                endTimes.indices.contains(endTimeIndex) else { return }

        let startTime = startTimes[startTimeIndex]
        let endTime = endTimes[endTimeIndex]
        
        didSelectTimes?(startTime, endTime)
      }
      
      // MARK: - Private helpers
      
      private func getTimes(of date: Date) -> [Date] {
        var times = [Date]()
        var currentDate = date
        
        currentDate = Calendar.current.date(bySetting: .hour, value: 7, of: currentDate)!
        currentDate = Calendar.current.date(bySetting: .minute, value: 00, of: currentDate)!
        
        let calendar = Calendar.current
        
        let interval = 60
        var nextDiff = interval - calendar.component(.minute, from: currentDate) % interval
        var nextDate = calendar.date(byAdding: .minute, value: nextDiff, to: currentDate) ?? Date()
        
        var hour = Calendar.current.component(.hour, from: nextDate)
        
        while(hour < 23) {
          times.append(nextDate)
          
          nextDiff = interval - calendar.component(.minute, from: nextDate) % interval
          nextDate = calendar.date(byAdding: .minute, value: nextDiff, to: nextDate) ?? Date()
          
          hour = Calendar.current.component(.hour, from: nextDate)
        }
        
        return times
      }
      
      
      private func setStartTimes() -> [Date] {
        let today = Date()
        return getTimes(of: today)
      }
      
      private func setEndTimes() -> [Date] {
        let today = Date()
        return getTimes(of: today)
      }
      
      
      private func getTimeString(from: Date) -> String {
        return timeFormatter.string(from: from)
      }
      
}
