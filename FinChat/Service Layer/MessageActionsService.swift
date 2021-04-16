//
//  MessageActionService.swift
//  FinChat
//
//  Created by Артём Мурашко on 16.04.2021.
//

import Foundation
import Firebase

protocol IMessageActions: class {
    func sendMessage(identifier: String, text: String?, uniqueID: String?, senderName: String)
}

class MessageActions: IMessageActions {
    private lazy var db = Firestore.firestore()
    
    func sendMessage(identifier: String, text: String?, uniqueID: String?, senderName: String) {
        if (text == "") { return }
        db.collection("channels").document(identifier).collection("messages").addDocument(data: ["content": text ?? "", "created": Date.init(), "senderId": uniqueID ?? "", "senderName": senderName])
    }
    
}
