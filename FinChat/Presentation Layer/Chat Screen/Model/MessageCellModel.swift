//
//  MessageCellModel.swift
//  FinChat
//
//  Created by Артём Мурашко on 16.04.2021.
//

import Foundation

protocol MessageCellConfiguration : class {
    var text : String? {get set}
    var date : Date {get set}
    var name : String {get set}
    var theme : VCTheme {get set}
}

class MessageCellPattern : MessageCellConfiguration {
    var text: String?
    var name : String
    var date : Date
    var theme: VCTheme
    
    init(text: String?, name: String, date: Date, theme: VCTheme) {
        self.text = text
        self.name = name
        self.date = date
        self.theme = theme
    }
}
