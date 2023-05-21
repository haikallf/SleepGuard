//
//  HomeView.swift
//  SleepGuard Watch App
//
//  Created by Haikal Lazuardi on 19/05/23.
//

import SwiftUI
import Combine

struct HomeView: View {
    var alarmViewModel: AlarmViewModel
    @State var currentWakeUpTime: Date?

    var body: some View {
        VStack {
            VStack (alignment: .leading) {
                HStack {
                    Image(systemName: "bed.double.fill")
                    Text("Sleep | Wake Up")
                }
                .foregroundColor(.white.opacity(0.7))
                
                VStack (alignment: .leading) {
                    Group {
                        if (currentWakeUpTime != nil) {
                            Text(alarmViewModel.formatTime(time: currentWakeUpTime!))
                        } else {
                            Text("No Alarm")
                        }
                    }
                    .font(.title2)
                    
                    Text(alarmViewModel.formatDay())
                        .font(.subheadline)
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
            .background(.white.opacity(0.1), in: RoundedRectangle(cornerRadius: 10))
            }
            
        }
        .navigationTitle {
          Text("SleepGuard")
                .foregroundColor(.orange)
        }
        .onAppear() {
            alarmViewModel.connectivityProvider.connect()
            currentWakeUpTime = alarmViewModel.connectivityProvider.wakeUpTime
            alarmViewModel.wakeUpTime = alarmViewModel.connectivityProvider.wakeUpTime
        }
        .onReceive(alarmViewModel.connectivityProvider.$wakeUpTime) { newData in
            currentWakeUpTime = newData
            alarmViewModel.wakeUpTime = newData
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(alarmViewModel: AlarmViewModel(connectivityProvider: ConnectionProvider()))
    }
}
