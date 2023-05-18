//
//  AlarmModel.swift
//  SleepGuard
//
//  Created by Haikal Lazuardi on 18/05/23.
//

import UIKit

class Alarm: NSObject, ObservableObject {
    @Published var wakeUpTime: Date?
    
    @Published var wakeUpType: String = WakeUpType.StandUp.rawValue
    
    @Published var standUpDuration: Int = 30
    
    @Published var walkSteps: Int = 10
    
    init(wakeUpTime: Date?, wakeUpType: String, standUpDuration: Int, walkSteps: Int) {
        self.wakeUpTime = wakeUpTime
        self.wakeUpType = wakeUpType
        self.standUpDuration = standUpDuration
        self.walkSteps = walkSteps
    }
    
    
//    public required convenience init?() {
//        self.init()
//        self.initWithData(wakeUpTime: wakeUpTime! as Date, wakeUpType: wakeUpType as String, standUpDuration: standUpDuration as Int, walkSteps: walkSteps as Int)
//    }
}
