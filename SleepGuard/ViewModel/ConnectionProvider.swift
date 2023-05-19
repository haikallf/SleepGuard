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
    
    @Published var wakeUpTime: Date = Date()
    var lastMessage: CFAbsoluteTime = 0
    @Published var receivedAlarm: Alarm?
    
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
    
    func sendAlarm(wakeUpTime: Date, wakeUpType: String, standUpDuration: Int, walkSteps: Int) {
        let alarm = Alarm()
        let alarmObj = alarm.initWithData(wakeUpTime: wakeUpTime, wakeUpType: wakeUpType, standUpDuration: standUpDuration, walkSteps: walkSteps)
        
        NSKeyedArchiver.setClassName("Alarm", for: Alarm.self)
        let alarmData = try! NSKeyedArchiver.archivedData(withRootObject: alarmObj, requiringSecureCoding: true)
        
        sendWatchMessage(alarmData)
    }
    
    func sendWatchMessage(_ alarmData: Data) {
        let currentTime = CFAbsoluteTimeGetCurrent()
        
//        if lastMessage + 0.5 > currentTime {
//            print("masuk")
//            return
//        }
        
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
            let loadedData = message["alarm"]
            
            NSKeyedUnarchiver.setClass(Alarm.self, forClassName: "Alarm")
            let unarchivedAlarmData = try! NSKeyedUnarchiver.unarchivedObject(ofClass: Alarm.self, from: loadedData as! Data)
            self.receivedAlarm = unarchivedAlarmData
            print("received: \(receivedAlarm?.wakeUpType ?? "default")")
        }
    }
    

}
