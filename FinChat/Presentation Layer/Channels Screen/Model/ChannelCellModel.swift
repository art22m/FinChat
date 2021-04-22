//
//  MessageCellModel.swift
//  FinChat
//
//  Created by Артём Мурашко on 16.04.2021.
//

import Foundation

protocol ConversationCellConfiguration: class {
    var identifier : String {get set}
    var name : String? {get set}
    var message : String? {get set}
    var date : Date? {get set}
    var theme : VCTheme {get set}
}

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
