//
//  ChangeWakeUpModal.swift
//  SleepGuard
//
//  Created by Haikal Lazuardi on 18/05/23.
//

import SwiftUI

struct ChangeWakeUpModal: View {
    @Environment(\.dismiss) var dismiss
    
    var alarmViewModel: AlarmViewModel
    @Binding var wakeUpTime: Date?
    @State var wakeUpType: String = WakeUpType.StandUp.rawValue
    @State var standUpDuration: Int = 30
    @State var walkSteps: Int = 10
    
    @State var selectedDate = Date()
    
    let wakeUpTypes: [WakeUpType] = WakeUpType.allCases

    var body: some View {
        VStack {
            DatePicker(
                    "Start Date",
                    selection: $selectedDate,
                    displayedComponents: [.hourAndMinute]
                )
            .datePickerStyle(WheelDatePickerStyle())
            .labelsHidden()
            
            VStack {
                HStack {
                    Text("Awake Confirmation")
                    Spacer()
                    Picker("", selection: $wakeUpType) {
                        ForEach(wakeUpTypes, id: \.self) {elmt in
                            Text(elmt.rawValue)
                                .tag(elmt.rawValue)
                        }
                    }
                    .foregroundColor(.white)
                }
                
                Divider()
                
                HStack {
                    Text("\(alarmViewModel.wakeUpType == WakeUpType.StandUp.rawValue ? "Duration" : "Steps")")
                    Spacer()
                    if (alarmViewModel.wakeUpType == WakeUpType.StandUp.rawValue) {
                        Picker("", selection: $standUpDuration) {
                            ForEach(1..<6, id: \.self) {elmt in
                                Text("\(elmt * 30)s")
                                    .tag(elmt * 30)
                            }
                        }
                    } else {
                        Picker("", selection: $walkSteps) {
                            ForEach(1..<6, id: \.self) {elmt in
                                Text("\(elmt * 10)")
                                    .tag(elmt * 10)
                            }
                        }
                    }
                }
            }
            .padding()
            .foregroundColor(.white)
            .background(Color("gray"))
            .cornerRadius(10)
            
            Button(action: {
                
            }) {
                Text("Delete Alarm")
                    .padding(.vertical, 12)
                    .frame(maxWidth: .infinity)
                    .foregroundColor(.red)
                    .background(Color("gray"))
                    .cornerRadius(10)
            }
            .padding(.top, 40)
            
            Spacer()
        }
        .padding()

        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Text("Cancel")
                    .foregroundColor(Color("yellow"))
                    .onTapGesture {
                        dismiss()
                    }
            }
            
            ToolbarItem(placement: .principal) {
                Text("Change Wake Up")
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Text("Done")
                    .fontWeight(.regular)
                    .foregroundColor(Color("yellow"))
                    .onTapGesture {
                        alarmViewModel.setWakeUpTime(selectedDate)
                        wakeUpTime = selectedDate
//                        alarmViewModel.wakeUpTime = selectedDate
                        alarmViewModel.wakeUpType = wakeUpType
                        alarmViewModel.standUpDuration = standUpDuration
                        alarmViewModel.walkSteps = walkSteps
                        
//                        alarmViewModel.connectivityProvider.sendAlarm(alarm: Alarm(wakeUpTime: alarmViewModel.wakeUpTime, wakeUpType: alarmViewModel.wakeUpType, standUpDuration: alarmViewModel.standUpDuration, walkSteps: alarmViewModel.walkSteps))
                        print(alarmViewModel.formatTime(time: alarmViewModel.wakeUpTime ?? Date()))
                        alarmViewModel.connectivityProvider.sendAlarm(wakeUpTime: alarmViewModel.wakeUpTime ?? Date(), wakeUpType: alarmViewModel.wakeUpType, standUpDuration: alarmViewModel.standUpDuration, walkSteps: alarmViewModel.walkSteps)
                        
                       
                        dismiss()
                    }
            }
        }
    }
}

struct ChangeWakeUpModal_Previews: PreviewProvider {
    static var previews: some View {
        ChangeWakeUpModal(alarmViewModel: AlarmViewModel(connectivityProvider: ConnectionProvider()), wakeUpTime: .constant(Date()))
            .preferredColorScheme(.dark)
    }
}
