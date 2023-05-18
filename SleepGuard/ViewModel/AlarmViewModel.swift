//
//  AlarmViewModel.swift
//  SleepGuard
//
//  Created by Haikal Lazuardi on 18/05/23.
//

import UIKit

class AlarmViewModel: NSObject, ObservableObject {
    @Published var wakeUpTime: Date?
    
    @Published var wakeUpType: String = WakeUpType.StandUp.rawValue
    
    @Published var standUpDuration: Int = 30
    
    @Published var walkSteps: Int = 10
    
    func formatTime(time: Date) -> String {
        let dateFormatterTemplate = DateFormatter()
        dateFormatterTemplate.setLocalizedDateFormatFromTemplate("HH.mm")
        return dateFormatterTemplate.string(from: time)
    }
    
    func getTimeOfDay() -> String {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour], from: self.wakeUpTime ?? Date())
        
        guard let hour = components.hour else {
            return ""
        }
        
        if hour < 12 {
            return "Morning"
        } else if hour < 17 {
            return "Afternoon"
        } else if hour < 20 {
            return "Evening"
        } else {
            return "Night"
        }
    }
    
    func formatDay() -> String {
        let calendar = Calendar.current
        
        var alarmMessage = ""
        
        if calendar.isDateInToday(self.wakeUpTime ?? Date()) {
            alarmMessage = "This "
        } else if calendar.isDateInTomorrow(self.wakeUpTime ?? Date()) {
            alarmMessage = "Tomorrow "
        } else {
            alarmMessage = "Who Knows"
        }
        
        alarmMessage = alarmMessage + getTimeOfDay()
        
        return alarmMessage
    }
}
