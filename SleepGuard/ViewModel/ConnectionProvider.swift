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
    @Published var receivedAlarm: String?
    
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
    
    func sendAlarm(wakeUpType: String) {
        sendWatchMessage(wakeUpType)
    }
    
    func sendWatchMessage(_ msgData: String) {
//        let currentTime = CFAbsoluteTimeGetCurrent()
        
//        if lastMessage + 0.5 > currentTime {
//            print("masuk")
//            return
//        }
        
        if (session.isReachable) {
            print("Sending message to watch")
            let message = ["alarm": msgData]
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
            DispatchQueue.main.async {
                self.receivedAlarm = loadedData as? String
            }
            print("received")
        }
    }
    

}
