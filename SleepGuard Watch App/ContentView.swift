//
//  ContentView.swift
//  SleepGuard Watch App
//
//  Created by Haikal Lazuardi on 18/05/23.
//

import SwiftUI

struct ContentView: View {
    @StateObject var alarmViewModel = AlarmViewModel(connectivityProvider: ConnectionProvider())
    var body: some View {
        NavigationView {
            NavigationLink(destination: HomeView(alarmViewModel: alarmViewModel, receivedAlarm: .constant("HUEHUE"))) {
                Text("Go")
            }
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
