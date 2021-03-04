//
//  CustomConversationTableViewCell.swift
//  FinChat
//
//  Created by Артём Мурашко on 01.03.2021.
//

import UIKit

protocol ConversationCellConfiguration : class {
    var name : String? {get set}
    var message : String? {get set}
    var date : Date? {get set}
    var online : Bool {get set}
    var hasUnreadMessages : Bool {get set}
}

class CustomConversationListTableViewCell: UITableViewCell {
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelMessage: UILabel!
    @IBOutlet weak var labelDate: UILabel!
    
    static let identifier = "CustomConversationListTableViewCell"
    static func nib() -> UINib {
        return UINib(nibName: "CustomConversationListTableViewCell", bundle: nil)
    }
    
    class Model : ConversationCellConfiguration {
        var name: String?
        var message: String?
        var date: Date?
        var online: Bool
        var hasUnreadMessages: Bool
        
        init(name: String?, message: String?, date: Date?, online: Bool, hasUnreadMessages: Bool) {
            self.name = name
            self.message = message
            self.date = date
            self.online = online
            self.hasUnreadMessages = hasUnreadMessages
        }
    }
    
    func configure(with pattern: Model) {
        if let name = pattern.name {
            self.labelName.text = name
        } else {
            self.labelName.text = "Unknown"
        }
        
        if let message = pattern.message {
            self.labelMessage.text = message
            self.labelMessage.font = UIFont.systemFont(ofSize: 17.0)
        } else {
            self.labelMessage.text = "No messages yet"
            self.labelMessage.font = UIFont(name: "Roboto", size: 17.0)
        }
        
        if let date = pattern.date {
            let calendar = NSCalendar.autoupdatingCurrent
            let formatter = DateFormatter()
            
            formatter.dateFormat = calendar.isDateInToday(date) ? "HH:mm" : "dd MMM"
            
            self.labelDate.text = formatter.string(from: date)
        } else {
            self.labelDate.text = ""
        }
        
        if pattern.online == true {
            self.contentView.backgroundColor = UIColor(red: 251.0/255.0, green: 242.0/255.0, blue: 212.0/255.0, alpha: 1.0)
        } else {
            self.contentView.backgroundColor = .white
        }
        
        if pattern.hasUnreadMessages == true {
            self.labelMessage.font = .boldSystemFont(ofSize: 17.0)
        } else {
            self.labelMessage.font = .systemFont(ofSize: 17.0)
        }
    }
}
