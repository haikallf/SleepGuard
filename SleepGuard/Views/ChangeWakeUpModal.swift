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
    @Binding var wakeUpType: String
    @Binding var standUpDuration: Int
    @Binding var walkSteps: Int
    
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
                        alarmViewModel.wakeUpTime = selectedDate
                        dismiss()
                    }
            }
        }
    }
}

struct ChangeWakeUpModal_Previews: PreviewProvider {
    static var previews: some View {
        ChangeWakeUpModal(alarmViewModel: AlarmViewModel(), wakeUpType: .constant("Stand Up"), standUpDuration: .constant(10), walkSteps: .constant(10))
            .preferredColorScheme(.dark)
    }
}
