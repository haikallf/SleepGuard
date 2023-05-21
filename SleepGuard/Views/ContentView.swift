//
//  ContentView.swift
//  SleepGuard
//
//  Created by Haikal Lazuardi on 18/05/23.
//

import SwiftUI

struct ContentView: View {
    @StateObject var alarmViewModel: AlarmViewModel = AlarmViewModel(connectivityProvider: ConnectionProvider())
    @StateObject var healthStore: HealthStore = HealthStore()
    let connect = ConnectionProvider()
    var body: some View {
        NavigationView {
            ZStack {
                Color("darkGray")
                    .ignoresSafeArea()
                CircularSliderView(alarmViewModel: alarmViewModel, healthStore: healthStore)
                    .preferredColorScheme(.dark)
            }
        }
        .onAppear() {
            print(UserDefaults.standard.object(forKey: "wakeUpType") == nil)
            alarmViewModel.askNotificationPermission()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.dark)
    }
}
