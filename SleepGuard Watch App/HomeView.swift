//
//  HomeView.swift
//  SleepGuard Watch App
//
//  Created by Haikal Lazuardi on 19/05/23.
//

import SwiftUI

struct HomeView: View {
    var alarmViewModel: AlarmViewModel
    @State var currentAlarm: String?
    init(alarmViewModel: AlarmViewModel){
        self.alarmViewModel = alarmViewModel
        // wrapped value for object
        self._currentAlarm = State(initialValue: alarmViewModel.connectivityProvider.receivedAlarm)
    }
    var body: some View {
        VStack {
////            Text(alarmViewModel.formatTime(time: alarmViewModel.wakeUpTime!))
//            Text(alarmViewModel.formatTime(time: currentDate ?? Date()))
            Text(currentAlarm ?? "HOHOH")
        }
        .onAppear() {
            alarmViewModel.connectivityProvider.connect()
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(alarmViewModel: AlarmViewModel(connectivityProvider: ConnectionProvider()))
    }
}
