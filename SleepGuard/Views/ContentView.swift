//
//  ContentView.swift
//  SleepGuard
//
//  Created by Haikal Lazuardi on 18/05/23.
//

import SwiftUI

struct ContentView: View {
    @StateObject var alarmViewModel: AlarmViewModel = AlarmViewModel(connectivityProvider: ConnectionProvider())
    let connect = ConnectionProvider()
    var body: some View {
        NavigationView {
            ZStack {
                Color("darkGray")
                    .ignoresSafeArea()
                CircularSliderView(alarmViewModel: alarmViewModel)
                    .preferredColorScheme(.dark)
            }
        }
//        .onAppear() {
//            connect.connect()
//        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.dark)
    }
}
