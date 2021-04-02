//
//  ObjectsExtension.swift
//  FinChat
//
//  Created by Артём Мурашко on 02.04.2021.
//

import Foundation
import CoreData

extension Channel_db {
    convenience init(name: String,
                     identifier: String,
                     lastActivity: Date,
                     lastMessage: String,
                     in context: NSManagedObjectContext) {
        self.init(context: context)
        self.name = name
        self.identifier = identifier
        self.lastActivity = lastActivity
        self.lastMessage = lastMessage
    }
    
    var getInfo: String {
        let description = "Channel name: \(String(describing: name ?? ""))"
        let count = ", number of messages: \(String(describing: self.messages?.allObjects.count ?? 0))"
        return description + count
    }
}

extension Message_db {
    convenience init(content: String,
                     created: Date,
                     messageId: String,
                     senderId: String,
                     senderName: String,
                     in context: NSManagedObjectContext) {
        self.init(context: context)
        self.content = content
        self.created = created
        self.messageId = messageId
        self.senderId = senderId
        self.senderName = senderName
    }
    var about: String {
            return "message: \(String(describing: content))"
        }
}
