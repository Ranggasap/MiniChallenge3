//
//  recordState.swift
//  MiniChallenge3
//
//  Created by Bryan Vernanda on 18/08/24.
//

//import Combine
//import WatchConnectivity
//
//final class Recording: ObservableObject {
//    var session: WCSession
//    let delegate: WCSessionDelegate
//    let subject = PassthroughSubject<Bool, Never>()
//    
//    @Published private(set) var record: Bool = false
//    
//    init(session: WCSession = .default) {
//        self.delegate = sendFileManager(recordStateSubject: subject)
//        self.session = session
//        self.session.delegate = self.delegate
//        if session.activationState != .activated {
//            self.session.activate()
//        }
//        
//        subject
//            .receive(on: DispatchQueue.main)
//            .assign(to: &$record)
//    }
//    
//    func toggleRecordState() {
//        record.toggle()
//        session.sendMessage(["recordState": record], replyHandler: nil) { error in
//            print(error.localizedDescription)
//        }
//    }
//}
