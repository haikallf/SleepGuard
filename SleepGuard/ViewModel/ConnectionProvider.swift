//
//  ConnectionProvider.swift
//  SleepGuard
//
//  Created by Haikal Lazuardi on 18/05/23.
//

import UIKit
import WatchConnectivity

class ConnectionProvider: NSObject, WCSessionDelegate {
    private let session: WCSession

    var lastMessage: CFAbsoluteTime = 0
    
    @Published var wakeUpTime: Date?
    
    @Published var heartRateGoal: Double?
    
    init(session: WCSession = .default) {
        self.session = session
        super.init()
        self.session.delegate = self
        
        #if os(iOS)
            print("Connection provider initialized on phone")
        #endif
        
        #if os(watchOS)
            print("Connection provider initialized on watch")
        #endif
        
        self.connect()
    }
    
    
    func connect() {
        guard WCSession.isSupported() else {
            print("WCSession is not supported")
            return
        }
        
        session.activate()
        print("activated")
    }
    
    func send(message: [String : Any]) -> Void {
        session.sendMessage(message, replyHandler: nil) { error in
            print(error.localizedDescription)
        }
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        //
    }
    
    #if os(iOS)
    func sessionDidBecomeInactive(_ session: WCSession) {
        //
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        //
    }
    #endif
    
    func convertDateToString(date: Date) -> String {
        let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            dateFormatter.timeZone = TimeZone.autoupdatingCurrent
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        return dateFormatter.string(from: date)
    }
    
    func convertStringToDate(str: String) -> Date {
        let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            dateFormatter.timeZone = TimeZone.autoupdatingCurrent
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        return dateFormatter.date(from: str)!
    }
    
    func sendAlarm(wakeUpTime: Date, heartRateGoal: Double) {
        let strAlarmData = "\(convertDateToString(date: wakeUpTime))++$$++\(heartRateGoal)"
        
        sendWatchMessage(strAlarmData)
    }
    
    func sendWatchMessage(_ alarmData: String) {
//        let currentTime = CFAbsoluteTimeGetCurrent()
        
//        if lastMessage + 0.5 > currentTime {
//            print("masuk")
//            return
//        }
        print("3")
        if (session.isReachable) {
            print("Sending message to watch")
            let message = ["alarm": alarmData]
            session.sendMessage(message, replyHandler: nil)
        } else {
            print("oh no")
        }
        
        lastMessage = CFAbsoluteTimeGetCurrent()
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        print("entered didreceive message")
        
        if (message["alarm"] != nil) {
            let receivedAlarmString: String = message["alarm"] as! String
            let receivedAlarmArr: [String] = receivedAlarmString.components(separatedBy: "++$$++")
            print(receivedAlarmArr)
            
            DispatchQueue.main.async {
                self.wakeUpTime = self.convertStringToDate(str: receivedAlarmArr[0])
                self.heartRateGoal = Double(receivedAlarmArr[1]) ?? 100
            }
        }
    }
}
