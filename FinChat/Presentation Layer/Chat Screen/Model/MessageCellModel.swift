//
//  MessageCellModel.swift
//  FinChat
//
//  Created by Артём Мурашко on 16.04.2021.
//

import Foundation

class ChannelCellPattern: ConversationCellConfiguration {
    var identifier: String
    var name: String?
    var message: String?
    var date: Date?
    var theme: VCTheme
    
    init(identifier: String, name: String?, message: String?, date: Date?) {
        self.identifier = identifier
        self.name = name
        self.message = message
        self.date = date
        self.theme = VCTheme()
    }
}
