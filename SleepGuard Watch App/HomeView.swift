//
//  HomeView.swift
//  SleepGuard Watch App
//
//  Created by Haikal Lazuardi on 19/05/23.
//

import SwiftUI

struct HomeView: View {
    var alarmViewModel: AlarmViewModel
    @Binding var receivedAlarm: String?
//    @State var currentAlarm: String?
    
//    init(alarmViewModel: AlarmViewModel){
//        self.alarmViewModel = alarmViewModel
//        // wrapped value for object
//        self._currentAlarm = State(initialValue: alarmViewModel.connectivityProvider.receivedAlarm)
//    }
    var body: some View {
        VStack {
//            Text(alarmViewModel.formatTime(time: alarmViewModel.connectivityProvider.receivedAlarm!))
//            Text(alarmViewModel.formatTime(time: currentDate ?? Date()))
            Text(receivedAlarm ?? "Tetot")
//            Text(currentAlarm ?? "HOHOH")
        }
        .onAppear() {
            alarmViewModel.connectivityProvider.connect()
//            self.currentAlarm = alarmViewModel.connectivityProvider.receivedAlarm
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(alarmViewModel: AlarmViewModel(connectivityProvider: ConnectionProvider()), receivedAlarm: .constant("tetet"))
    }
}
