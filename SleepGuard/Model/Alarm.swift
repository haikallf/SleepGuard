//
//  AlarmModel.swift
//  SleepGuard
//
//  Created by Haikal Lazuardi on 18/05/23.
//

import SwiftUI

struct Alarm: Identifiable {
    let id = UUID()
    let hour: Int
    let minute: Int
    let isEnabled: Bool
}
