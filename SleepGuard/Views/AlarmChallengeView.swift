//
//  AlarmChallengeView.swift
//  SleepGuard
//
//  Created by Haikal Lazuardi on 22/05/23.
//

import SwiftUI

struct AlarmChallengeView: View {
    var alarmViewModel: AlarmViewModel
    @State var dummyHeartRate: Double = 90
    
    var body: some View {
        ZStack {
            VStack {
                Text(alarmViewModel.formatDate(time: Date()))
                
                Text(alarmViewModel.formatTime(time: Date()))
                    .font(.system(size: 60).bold())
                
                Spacer()
            }
            
            LottieView(name: "heart-beat", animationSpeed: 1.5)
                .opacity(0.3)
            
            VStack {
                Text("Heart Rate Goal: ") + Text("\(alarmViewModel.heartRateGoal, specifier: "%.0f") bpm")
                    .foregroundColor(Color("yellow"))
                
                HStack {
//                    Text("-")
//                        .onTapGesture {
//                            alarmViewModel.decrementDummyHeartRate()
//                        }
                    
                    Text("\(alarmViewModel.dummyHeartRate , specifier: "%.0f")")
                
//                    Text("+")
//                        .onTapGesture {
//                            alarmViewModel.incrementDummyHeartRate()
//                        }
                }
                .font(.system(size: 72))
                Button {
                    alarmViewModel.stopSound()
                    alarmViewModel.isChallengeViewShown = false
                } label: {
                    Text("Cancel")
                }
            }
        }
        .onReceive(alarmViewModel.$dummyHeartRate) { newHeartRate in
            if (newHeartRate >= alarmViewModel.heartRateGoal) {
                dummyHeartRate = newHeartRate
                alarmViewModel.stopSound()
                alarmViewModel.isChallengeViewShown = false
            }
        }
        .padding()
//        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct AlarmChallengeView_Previews: PreviewProvider {
    static var previews: some View {
        AlarmChallengeView(alarmViewModel: AlarmViewModel(connectivityProvider: ConnectionProvider()))
    }
}
