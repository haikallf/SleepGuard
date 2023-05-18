//
//  ChangeWakeUpModal.swift
//  SleepGuard
//
//  Created by Haikal Lazuardi on 18/05/23.
//

import SwiftUI

struct ChangeWakeUpModal: View {
    @Environment(\.dismiss) var dismiss
    
    @Binding var wakeUpTime: Date?
    @State var selectedDate = Date()
    @State var wakeUpType: String = WakeUpType.StandUp.rawValue
    @State var standUpDuration: Int = 30
    @State var walkSteps: Int = 10
    let wakeUpTypes: [WakeUpType] = WakeUpType.allCases
    
    func formatTime(time: Date) -> String {
        let dateFormatterTemplate = DateFormatter()
        dateFormatterTemplate.setLocalizedDateFormatFromTemplate("dd mm yy HH:mm")
        return dateFormatterTemplate.string(from: time)
    }
    
    var body: some View {
        VStack {
            DatePicker(
                    "Start Date",
                    selection: $selectedDate,
                    displayedComponents: [.hourAndMinute]
                    
                )
            .datePickerStyle(WheelDatePickerStyle())
            .labelsHidden()
            
//            Text(formatTime(time: selectedDate))
            
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
                    Text("\(wakeUpType == WakeUpType.StandUp.rawValue ? "Duration" : "Steps")")
                    Spacer()
                    if (wakeUpType == WakeUpType.StandUp.rawValue) {
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
//        .onAppear {
//            print(wakeUpTypes)        }
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
                        wakeUpTime = selectedDate
                        dismiss()
                    }
            }
        }
    }
}

struct ChangeWakeUpModal_Previews: PreviewProvider {
    static var previews: some View {
        ChangeWakeUpModal(wakeUpTime: .constant(Date()))
            .preferredColorScheme(.dark)
    }
}
