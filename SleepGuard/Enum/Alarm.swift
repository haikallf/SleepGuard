//
//  AlarmModel.swift
//  SleepGuard
//
//  Created by Haikal Lazuardi on 18/05/23.
//

import UIKit

class Alarm: NSObject, ObservableObject, NSCoding {
    let id = UUID()
    @Published var wakeUpTime: Date?
    
    @Published var wakeUpType: String = WakeUpType.StandUp.rawValue
    
    @Published var standUpDuration: Int = 30
    
    @Published var walkSteps: Int = 10
    
    init (wakeUpTime: Date?, wakeUpType: String, standUpDuration: Int, walkSteps: Int) {
        self.wakeUpTime = wakeUpTime
        self.wakeUpType = wakeUpType
        self.standUpDuration = standUpDuration
        self.walkSteps = walkSteps
    }
    
    public required convenience init?(coder: NSCoder) {
        guard let wakeUpTime = coder.decodeObject(forKey: "wakeUpTime") as? Date,
              let wakeUpType = coder.decodeObject(forKey: "wakeUpType") as? String,
              let standUpDuration = coder.decodeObject(forKey: "standUpDuration") as? Int,
              let walkSteps = coder.decodeObject(forKey: "walkSteps") as? Int
        else { return nil }
        
//        self.init()
        
        self.init(wakeUpTime: wakeUpTime as Date?, wakeUpType: wakeUpType as String, standUpDuration: standUpDuration as Int, walkSteps: walkSteps as Int)
    }
    
    public func encode(with coder: NSCoder) {
        coder.encode(self.wakeUpTime, forKey: "wakeUp")
        coder.encode(self.wakeUpType, forKey: "wakeUpType")
        coder.encode(self.standUpDuration, forKey: "standUpDuration")
        coder.encode(self.walkSteps, forKey: "walkSteps")
    }
    
//    public required convenience init?() {
//        self.init()
//        self.initWithData(wakeUpTime: wakeUpTime! as Date, wakeUpType: wakeUpType as String, standUpDuration: standUpDuration as Int, walkSteps: walkSteps as Int)
//    }
}
