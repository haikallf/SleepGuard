//
//  HomeView.swift
//  SleepGuard Watch App
//
//  Created by Haikal Lazuardi on 19/05/23.
//

import SwiftUI

struct HomeView: View {
    var alarmViewModel: AlarmViewModel
    @State var currentWakeUpTime: Date?
//    @State var currentAlarm: String?
    
//    init(alarmViewModel: AlarmViewModel){
//        self.alarmViewModel = alarmViewModel
//        // wrapped value for object
//        self._currentAlarm = State(initialValue: alarmViewModel.connectivityProvider.receivedAlarm)
//    }
    var body: some View {
        VStack {
            if (currentWakeUpTime != nil) {
                Text(alarmViewModel.formatTime(time: currentWakeUpTime!))
            } else {
                Text("No Alarm")
                    
            }
        }
        .navigationTitle {
          Text("Header")
                .foregroundColor(.orange)
        }
        .onAppear() {
            alarmViewModel.connectivityProvider.connect()
            currentWakeUpTime = alarmViewModel.connectivityProvider.wakeUpTime
        }
        .onReceive(alarmViewModel.connectivityProvider.$wakeUpTime) { newData in
            currentWakeUpTime = newData
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(alarmViewModel: AlarmViewModel(connectivityProvider: ConnectionProvider()))
    }
}
