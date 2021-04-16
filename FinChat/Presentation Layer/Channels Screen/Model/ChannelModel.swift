//
//  ChannelModel.swift
//  FinChat
//
//  Created by Артём Мурашко on 16.04.2021.
//

import Foundation

struct ChannelModel {
    let identifier: String
    let name: String
    let lastMessage: String?
    let lastActivity: Date?
    
    init() {
        identifier = ""
        name = ""
        lastMessage = ""
        lastActivity = Date.init()
    }
    
    init(identifier: String, name: String, lastMessage: String?, lastActivity: Date?) {
        self.identifier = identifier
        self.name = name
        self.lastMessage = lastMessage
        self.lastActivity = lastActivity
    }
}
