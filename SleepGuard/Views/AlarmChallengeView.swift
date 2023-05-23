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
    @State var isAnimationPlayed: Bool = false
    
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
                    Text("-")
                        .onTapGesture {
                            alarmViewModel.decrementDummyHeartRate()
                        }
                    
                    Text("\(alarmViewModel.dummyHeartRate , specifier: "%.0f")")
                
                    Text("+")
                        .onTapGesture {
                            alarmViewModel.incrementDummyHeartRate()
                        }
                }
                .font(.system(size: 72))
                Button {
                    isAnimationPlayed = true
//                    alarmViewModel.stopSound()
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                        withAnimation {
                            alarmViewModel.isChallengeViewShown = false
                        }
                    }
                } label: {
                    Text("Done")
                }
            }
            
            Circle()
                .fill(Color("yellow"))
                .frame(width: isAnimationPlayed ? 20 : 1)
                .scaleEffect(isAnimationPlayed ? 100 : 1)
                .animation(Animation.easeOut(duration: 0.5), value: isAnimationPlayed)
            
            if (isAnimationPlayed) {
                ZStack {
                    LottieView(name: "success", loopMode: .playOnce,   animationSpeed: 1)
                        .opacity(1)
                        .scaleEffect(0.4)
                    
                    Text("Success!")
                        .font(.title.bold())
                        .padding(.top, 300)
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
