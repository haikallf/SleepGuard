//
//  AlarmViewModel.swift
//  SleepGuard
//
//  Created by Haikal Lazuardi on 18/05/23.
//

import UIKit
import UserNotifications

class AlarmViewModel: NSObject, ObservableObject {
    private(set) var connectivityProvider: ConnectionProvider
    
    @Published var wakeUpTime: Date?
    
    @Published var heartRateGoal: Double
    
    @Published var alarms: [Alarm] = []
    
    init(connectivityProvider: ConnectionProvider) {
        self.heartRateGoal = 100
        self.connectivityProvider = connectivityProvider
        self.connectivityProvider.connect()
    }
    
    func setWakeUpTime(_ wakeUpTime: Date) {
        self.wakeUpTime = wakeUpTime
    }
    
    func adjustTimeOnCurrentDate(hour: Int, minute: Int) -> Date {
        var existingDate = Date()

        // Desired time components
        var timeComponents = DateComponents()
        timeComponents.timeZone = TimeZone(abbreviation: "ICT")
        timeComponents.hour = hour
        timeComponents.minute = minute
        timeComponents.second = 0

        // Create a calendar instance
        let calendar = Calendar.current

        // Set the time on the existing date
        existingDate = calendar.date(bySettingHour: timeComponents.hour ?? 0, minute: timeComponents.minute ?? 0, second: timeComponents.second ?? 0, of: existingDate) ?? existingDate
        
        return existingDate
    }
    
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
    
    func askNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                print ("Access granted!")
            } else if let error = error {
                print (error.localizedDescription)
            }
        }
    }
    
    func sendNotification(date: Date, type: String, timeInterval: Double = 10, title: String, body: String) {
        var trigger: UNNotificationTrigger?
        
        // Create a trigger (either from date or time based)
        if type == "date" {
            let dateComponents = Calendar.current.dateComponents([.day, .month, .year, .hour, .minute], from: date)
            trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        } else if type == "time" {
            trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
        }
        
        // Customise the content
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = UNNotificationSound.default
        
        // Create the request
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }
    
    func showFullScreenNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Alarm"
        content.body = "Wake up!"
        content.sound = UNNotificationSound.default
        content.categoryIdentifier = "AlarmCategory"
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling alarm: \(error.localizedDescription)")
            } else {
                print("Alarm scheduled successfully")
            }
        }
    }
}
