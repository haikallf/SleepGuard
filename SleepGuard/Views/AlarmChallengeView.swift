//
//  AlarmChallengeView.swift
//  SleepGuard
//
//  Created by Haikal Lazuardi on 22/05/23.
//

import SwiftUI

struct AlarmChallengeView: View {
    @ObservedObject var alarmViewModel: AlarmViewModel
    @StateObject var heartRateViewModel: HeartRateViewModel = HeartRateViewModel()
    @State var dummyHeartRate: Double = 90
    @State var isAnimationPlayed: Bool = false
    @State var isHeartBeating: Bool = false
    
    var body: some View {
        ZStack {
            VStack {
                Text(alarmViewModel.formatDate(time: Date()))
                
                Text(alarmViewModel.formatTime(time: Date()))
                    .font(.system(size: 38).bold())
                
                Spacer()
            }
            .padding(.top, 60)
            
            LottieView(name: "heart-beat-graph", animationSpeed: 1.5)
                .opacity(0.3)
            
            VStack {
                HStack {
                    VStack {
                        LottieView(name: "68659-heartbeat", animationSpeed: 5)
                            .scaleEffect(0.7)
                    }
                    .padding(.top, 20)
                    .padding(.trailing, -16)
                    .frame(width: 60)
                    
                    Group {
                        if (alarmViewModel.isDebugMode) {
                            Text("\(alarmViewModel.dummyHeartRate , specifier: "%.0f")")
                                .font(.system(size: 92)) + Text("bpm")
                                .font(.title)
                        } else {
                            if (heartRateViewModel.latestHeartRate.isZero) {
                                Text("-- ")
                                    .font(.system(size: 92)) + Text("bpm")
                                    .font(.title)
                            } else {
                                Text("\(heartRateViewModel.latestHeartRate , specifier: "%.0f")")
                                    .font(.system(size: 92)) + Text("bpm")
                                    .font(.title)
                            }
                        }
                    }
                }
            }
            
            VStack {
                Spacer()
                    .frame(height: 400)
                
                Text("Heart Rate Goal: ") + Text("\(alarmViewModel.heartRateGoal, specifier: "%.0f") bpm")
                    .foregroundColor(Color("yellow"))
                
                Spacer()
                    .frame(height: 24)
                
                Button {
                    if (alarmViewModel.isDebugMode) {
                        isAnimationPlayed = true
                        alarmViewModel.stopSound()
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                            withAnimation {
                                alarmViewModel.isChallengeViewShown = false
                            }
                        }
                    } else {
//                        heartRateViewModel.startHeartRateDetection()
                    }
                } label: {
                    Text(alarmViewModel.isDebugMode ? "Done" : "Start Scanning")
                        .padding(.vertical)
                        .frame(maxWidth: .infinity)
                        .background(Color("gray"), in: RoundedRectangle(cornerRadius: 10))
                }
                .padding(.horizontal)
            }
            
            if (alarmViewModel.isDebugMode) {
                VStack(spacing: -6) {
                    Spacer()
                    
                    Text("Adjust Heart Rate")
                    HStack {
                        Button {
                            alarmViewModel.decrementDummyHeartRate()
                        } label: {
                            Text("-")
                        }
                        .frame(maxWidth: .infinity)
                        
                        Button {
                            alarmViewModel.incrementDummyHeartRate()
                        } label: {
                            Text("+")
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .padding()
                    .background(Color("gray"))
                    .frame(height: 80)
                }
                .ignoresSafeArea()
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
                
                isAnimationPlayed = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                    withAnimation {
                        alarmViewModel.isChallengeViewShown = false
                    }
                }
            }
        }
        .navigationBarHidden(true)
//        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct AlarmChallengeView_Previews: PreviewProvider {
    static var previews: some View {
        AlarmChallengeView(alarmViewModel: AlarmViewModel(connectivityProvider: ConnectionProvider()))
    }
}
