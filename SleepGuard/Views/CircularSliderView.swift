//
//  CircularSliderView.swift
//  SleepGuard
//
//  Created by Haikal Lazuardi on 20/05/23.
//

import SwiftUI

struct CircularSliderView: View {
    var alarmViewModel: AlarmViewModel
    @State var shouldScroll: Bool = true
    
    @State var startAngle: Double = 0
    @State var endAngle: Double = 180
    
    @State var startProgress: CGFloat = 0
    @State var endProgress: CGFloat = 0.5
    
    @State var hourDiff: Int = 12
    @State var minDIff: Int = 0
    
    @State var sleepTime: Date?
    @State var wakeUpTime: Date?
    @State var wakeUpType: String
    @State var standUpDuration: Int
    @State var walkSteps: Int
    
    init(alarmViewModel: AlarmViewModel) {
        self.alarmViewModel = alarmViewModel
        
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        let sleep = self.alarmViewModel.adjustTimeOnCurrentDate(hour: 22, minute: 0)
        let wakeUp = self.alarmViewModel.adjustTimeOnCurrentDate(hour: 6, minute: 0)
        
        if UserDefaults.standard.object(forKey: "sleepTime") == nil {
            _sleepTime = State(initialValue: sleep)
        } else {
            _sleepTime = State(initialValue: UserDefaults.standard.object(forKey: "sleepTime") as! Date)
        }
        
        if UserDefaults.standard.object(forKey: "wakeUpTime") == nil {
            _wakeUpTime = State(initialValue: wakeUp)
        } else {
            _wakeUpTime = State(initialValue: UserDefaults.standard.object(forKey: "wakeUpTime") as! Date)
        }
        
        if UserDefaults.standard.object(forKey: "wakeUpType") == nil {
            _wakeUpType = State(initialValue: (UserDefaults.standard.string(forKey: "wakeUpType") ?? "Stand Up"))
        } else {
            _wakeUpType = State(initialValue: UserDefaults.standard.string(forKey: "wakeUpType")!)
        }

        if UserDefaults.standard.object(forKey: "standUpDuration") == nil {
            _standUpDuration = State(initialValue: 60)
        } else {
            _standUpDuration = State(initialValue: UserDefaults.standard.integer(forKey: "walkSteps"))
        }

        if UserDefaults.standard.object(forKey: "walkSteps") == nil {
            _walkSteps = State(initialValue: 20)
        } else {
            _walkSteps = State(initialValue: UserDefaults.standard.integer(forKey: "walkSteps"))
        }
    }
    
    let wakeUpTypes: [WakeUpType] = WakeUpType.allCases
    
    var body: some View {
        ScrollView {
            VStack {
                VStack(spacing: 25) {
                    HStack(spacing: 25) {
                        VStack(alignment: .leading, spacing: 8) {
                            Label {
                                Text("Bedtime")
                                    .foregroundColor(.white)
                            } icon: {
                                Image(systemName: "bed.double.fill")
                                    .foregroundColor(Color("yellow"))
                            }
                            .font(.callout)
                            
                            Text(getTime(angle: startAngle, isStartAngle: 1).formatted(date: .omitted, time: .shortened))
                                .font(.title2.bold())
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Label {
                                Text("Wake Up")
                                    .foregroundColor(.white)
                            } icon: {
                                Image(systemName: "alarm.waves.left.and.right.fill")
                                    .foregroundColor(Color("yellow"))
                            }
                            .font(.callout)
                            
                            Text(getTime(angle: endAngle, isStartAngle: -1).formatted(date: .omitted, time: .shortened))
                                .font(.title2.bold())
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                    }
                    
                    SleepTimeSlider()
                    
                    VStack {
                        Text("\(getTimeDifference().0)hr \(getTimeDifference().1)min")
                            .font(.title3.bold())
                        
                        HStack {
                            Text(getTimeDifference().0 >= 8 ? "This schedule meets your sleep goals" : "Below sleep goals")
                                .foregroundColor(getTimeDifference().0 >= 8 ? .white.opacity(0.5) : Color("yellow"))
                                .font(.subheadline)
                        }
                    }
                }
                .padding()
                .background(Color("gray"), in: RoundedRectangle(cornerRadius: 10))
                
                Text("Wake Up Options")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.title2.bold())
                    .padding(.top)
                
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
                .padding([.vertical, .leading])
                .foregroundColor(.white)
                .background(Color("gray"))
                .cornerRadius(10)
                
                Button {
                    sleepTime = getTime(angle: startAngle)
                    wakeUpTime = getTime(angle: endAngle)
                    
                    alarmViewModel.wakeUpTime = wakeUpTime
                    alarmViewModel.wakeUpType = wakeUpType
                    alarmViewModel.standUpDuration = standUpDuration
                    alarmViewModel.walkSteps = walkSteps
                    
                    alarmViewModel.connectivityProvider.sendAlarm(wakeUpTime: alarmViewModel.wakeUpTime ?? Date(), wakeUpType: alarmViewModel.wakeUpType, standUpDuration: alarmViewModel.standUpDuration, walkSteps: alarmViewModel.walkSteps)
                    print("sleepTime: \(getTime(angle: startAngle))")
                    print("wakeUpTime: \(wakeUpTime)")
                    print("wakeUpType: \(wakeUpType)")
                    print("standUpDuration: \(standUpDuration)")
                    print("walkSteps: \(walkSteps)")
                } label: {
                    Text("Set Alarm")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color("gray"), in: RoundedRectangle(cornerRadius: 10))
                }
                .padding(.top)
                
                Spacer()
            }
            .onAppear() {
//                let formatter = DateFormatter()
//                formatter.dateFormat = "HH:mm:ss"
//                let sleep = formatter.date(from: "00:00:00")
//                let wakeUp = formatter.date(from: "00:08:00")
//                alarmViewModel.connectivityProvider.connect()
//
//                if UserDefaults.standard.object(forKey: "sleepTime") == nil {
//                    sleepTime = sleep
//                }
//
//                if UserDefaults.standard.object(forKey: "wakeUpTime") == nil {
//                    wakeUpTime = wakeUp
//                }
//
//                if UserDefaults.standard.object(forKey: "wakeUpType") == nil {
//                    wakeUpType = "Walk"
//                }
//
//                if UserDefaults.standard.object(forKey: "standUpDuration") == nil {
//                    standUpDuration = 60
//                }
//
//                if UserDefaults.standard.object(forKey: "walkSteps") == nil {
//                    walkSteps = 10
//                }
        
            }
            .padding()
            .navigationTitle("SleepGuard")
        }
    }
    
    @ViewBuilder
    func SleepTimeSlider() -> some View {
        GeometryReader { proxy in
            let width = proxy.size.width
            
            ZStack {
                // Clock
                ZStack {
                    ForEach(1...120, id: \.self) { index in
                        Rectangle()
                            .fill(index % 5 == 0 ? .gray : .gray)
                            .frame(width: 2, height: index % 5 == 0 ? 8 : 2)
                            .offset(y: (width - 60) / 2)
                            .rotationEffect(.init(degrees: Double(index) * 3))
                    }
                    
                    // Clock Text
                    let texts = [12, 14, 16, 18, 20, 22, 0, 2, 4, 6, 8, 10]
                    ForEach(texts.indices, id: \.self) { index in
                        Text("\(texts[index])")
                            .font(.callout.bold())
                            .foregroundColor(.gray)
                            .rotationEffect(.init(degrees: Double(index) * -30))
                            .offset(y: (width - 90) / 2)
                            // 360 / 12 = 30
                            .rotationEffect(.init(degrees: Double(index) * 30))
                    }
                    
                    Image.init(systemName: "sun.max.fill")
                        .foregroundColor(.yellow)
                        .offset(y: (width - 150) / 2)
                    
                    Image.init(systemName: "sparkles")
                        .foregroundColor(Color("lightBlue"))
                        .offset(y: (width - 350) / 2)
                }
                
                // Slider
                Circle()
                    .stroke(.black, lineWidth: 40)
                
                // Allow reverse slide
                let reverseRotation = (startProgress > endProgress) ? -Double((1 - startProgress) * 360) : 0
                Circle()
                    .trim(from: startProgress > endProgress ? 0 : startProgress, to: endProgress + (-reverseRotation / 360))
                    .stroke(getTimeDifference().0 >= 8 ? Color("gray") : Color("yellow") , style: StrokeStyle(lineWidth: 25, lineCap: .round, lineJoin: .round))
                    .rotationEffect(.init(degrees: -90))
                    .rotationEffect(.init(degrees: reverseRotation))
                
                Image(systemName: "bed.double.fill")
                    .resizable()
                    .font(.callout)
                    .foregroundColor(getTimeDifference().0 >= 8 ? Color("tertiaryGray") : Color("brown"))
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 15)
                    .rotationEffect(.init(degrees: 90))
                    .rotationEffect(.init(degrees: -startAngle))
                    .offset(x: width / 2)
                    .rotationEffect(.init(degrees: startAngle))
                    .gesture(
                        DragGesture()
                            .onChanged({ value in
                                onDrag(value: value, fromSlider: true)
                            })
                    )
                    .rotationEffect(.init(degrees: -90))
                
                Image(systemName: "alarm.waves.left.and.right.fill")
                    .resizable()
                    .font(.callout)
                    .foregroundColor(getTimeDifference().0 >= 8 ? Color("tertiaryGray") : Color("brown"))
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 15)
                    .rotationEffect(.init(degrees: 90))
                    .rotationEffect(.init(degrees: -endAngle))
                    .offset(x: width / 2)
                    .rotationEffect(.init(degrees: endAngle))
                    .gesture(
                        DragGesture()
                            .onChanged({ value in
                                onDrag(value: value)
                            })
                    )
                    .rotationEffect(.init(degrees: -90))
            }
        }
        .frame(width: screenBounds().width / 1.6, height: screenBounds().width / 1.6)
        .padding(.bottom)
    }
    
    private var axes: Axis.Set {
            return shouldScroll ? .horizontal : []
    }
    
    func onDrag(value: DragGesture.Value, fromSlider: Bool = false) {
        // Translation into angle
        
        let vector = CGVector(dx: value.location.x, dy: value.location.y)
        
        // Remove button radius
        let radians = atan2(vector.dy - 15, vector.dx - 15)
        
        var angle = radians * 180 / .pi
        
        if (angle < 0) {
            angle = 360 + angle
        }
        
        let progress = angle / 360
        
        if (fromSlider) {
            self.startAngle = angle
            self.startProgress = progress
        } else {
            self.endAngle = angle
            self.endProgress = progress
        }
    }
    
    
    
    // Get time based on drag
    func getTime(angle: Double, isStartAngle: Int = 0) -> Date {
        // 360 / 24 = 15
        // 24 = hours
        let progress = angle / 15
        
        let hour = Int(progress)
        // 12 => 60/12 = 5 => every 5m
        let remainder = (progress.truncatingRemainder(dividingBy: 1) * 24).rounded()
        
        var minute = remainder * 5
        // avoid perfect time
        minute = (minute > 55 ? 55 : minute)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        
//        if let date = formatter.date(from: "\(hour):\(Int(minute)):00") {
////            if isStartAngle == 1 {
////                sleepTime = date
////            } else if isStartAngle == -1 {
////                wakeUpTime = date
////            }
//            return date
//        }
        
        if let date = formatter.date(from: "\(hour):\(Int(minute)):00") {
            return alarmViewModel.adjustTimeOnCurrentDate(hour: hour, minute: Int(minute))
        }
        
        return .init()
    }
    
    func getTimeDifference() -> (Int, Int) {
        let calendar = Calendar.current
        let result = calendar.dateComponents([.hour, .minute], from: getTime(angle: startAngle), to: getTime(angle: endAngle))
        let hour = result.hour! < 0 ? result.hour! + 24 : result.hour!
        let minute = result.minute! < 0 ? result.minute! + 60 : result.minute!
        
        return (hour, minute)
    }
}

struct CircularSliderView_Previews: PreviewProvider {
    static var previews: some View {
        CircularSliderView(alarmViewModel: AlarmViewModel(connectivityProvider: ConnectionProvider()))
    }
}

extension View {
    // Screen Bounds Extension
    func screenBounds() -> CGRect {
        return UIScreen.main.bounds
    }
}
