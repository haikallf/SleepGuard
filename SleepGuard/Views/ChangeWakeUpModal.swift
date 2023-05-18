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
    let dateFormatter = DateFormatter()
    
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
            
            Text(formatTime(time: selectedDate))
            
            Spacer()
        }
//        .onAppear {
//            wakeUpTime = wakeUpTime ?? Date()
//        }
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
