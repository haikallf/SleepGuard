//
//  AlarmViewModel.swift
//  SleepGuard
//
//  Created by Haikal Lazuardi on 18/05/23.
//

import UIKit

class AlarmViewModel: NSObject, ObservableObject, NSSecureCoding {
    public static var supportsSecureCoding: Bool = true
    
    @Published var wakeUpTime: Date?
    
    public required init?(coder: NSCoder) {
        
    }
    
    public func encode(with coder: NSCoder) {
        
    }
    
}
