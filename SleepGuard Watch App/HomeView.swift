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

    var body: some View {
        VStack {
            
            Text(currentAlarm ?? "No Alarm")
            
        }
        .navigationTitle {
          Text("Header")
                .foregroundColor(.orange)
        }
        .onAppear() {
            alarmViewModel.connectivityProvider.connect()
            currentAlarm = alarmViewModel.connectivityProvider.receivedAlarm
        }
        .onReceive(alarmViewModel.connectivityProvider.$receivedAlarm) { newData in
            currentAlarm = newData
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(alarmViewModel: AlarmViewModel(connectivityProvider: ConnectionProvider()))
    }
}
