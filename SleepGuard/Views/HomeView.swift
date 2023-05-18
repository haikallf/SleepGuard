//
//  HomeView.swift
//  SleepGuard
//
//  Created by Haikal Lazuardi on 18/05/23.
//

import SwiftUI

struct HomeView: View {
    @State var isChangeWakeUpModalShown: Bool = false
    @State var wakeUpTime: Date?
    
    func formatTime(time: Date) -> String {
        let dateFormatterTemplate = DateFormatter()
        dateFormatterTemplate.setLocalizedDateFormatFromTemplate("HH.mm")
        return dateFormatterTemplate.string(from: time)
    }
    
    func getTimeOfDay() -> String {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour], from: wakeUpTime ?? Date())
        
        guard let hour = components.hour else {
            return ""
        }
        
        if hour < 12 {
            return "Morning"
        } else if hour < 17 {
            return "Afternoon"
        } else if hour < 20 {
            return "Evening"
        } else {
            return "Night"
        }
    }
    
    func formatDay() -> String {
        let calendar = Calendar.current
        
        var alarmMessage = ""
        
        if calendar.isDateInToday(wakeUpTime ?? Date()) {
            alarmMessage = "This "
        } else if calendar.isDateInTomorrow(wakeUpTime ?? Date()) {
            alarmMessage = "Tomorrow "
        } else {
            alarmMessage = "Who Knows"
        }
        
        alarmMessage = alarmMessage + getTimeOfDay()
        
        return alarmMessage
    }
    var body: some View {
        VStack {            
            ZStack {
                Circle()
                    .trim(from: 0, to: 1)
                    .stroke(Color.gray.opacity(0.09), style: StrokeStyle(lineWidth: 20, lineCap: .round))
                    .frame(width: 220)
                
                Circle()
                    .trim(from: 0, to: 0.5)
                    .stroke(Color("yellow"), style: StrokeStyle(lineWidth: 20, lineCap: .round))
                    .frame(width: 220)
                    .rotationEffect(.init(degrees: -90))
                
                VStack {
                    Text("7hr 16m")
                        .font(.title)
                        .fontWeight(.semibold)
                    
                    Text("remaining")
                        .font(.callout)
                }
            }
            .padding(.vertical, 48)
            
            HStack {
                Image(systemName: "bed.double.fill")
                    .padding(.trailing, -4)
                
                Text("Sleep | Wake Up")
                    .fontWeight(.semibold)
                
                Spacer()
            }
            .font(.title3)
            
            Divider()
                .padding(.top, -10)
            
            HStack {
                VStack (alignment: .leading) {
                    Text(formatTime(time: wakeUpTime ?? Date()))
                        .font(.system(size: 45))
                    
                    Text(formatDay())
                        .font(.subheadline)
                }
                .fontWeight(.light)
                
                Spacer()
                
                Button(action: {
                    isChangeWakeUpModalShown.toggle()
                }, label: {
                    Text("CHANGE")
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .font(.subheadline)
                        .foregroundColor(Color("yellow"))
                        .background(Color("darkGray"))
                        .fontWeight(.semibold)
                        .sheet(isPresented: $isChangeWakeUpModalShown) {
                            NavigationView {
                                ChangeWakeUpModal(wakeUpTime: $wakeUpTime)
                            }
                        }
                })
                .clipShape(Capsule())
            }
            .padding(.top, -16)
            
            Divider()
            
            Spacer()
        }
        .padding()
        .navigationTitle("SleepGuard")
    }  
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .preferredColorScheme(.dark)
    }
}
