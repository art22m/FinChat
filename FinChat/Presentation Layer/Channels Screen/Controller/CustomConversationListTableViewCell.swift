//
//  CustomConversationTableViewCell.swift
//  FinChat
//
//  Created by Артём Мурашко on 01.03.2021.
//

import UIKit

protocol ConversationCellConfiguration: class {
    var identifier : String {get set}
    var name : String? {get set}
    var message : String? {get set}
    var date : Date? {get set}
    var theme : VCTheme {get set}
}

class CustomChannelTableViewCell: UITableViewCell {
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelMessage: UILabel!
    @IBOutlet weak var labelDate: UILabel!
    
    static let identifier = "CustomChannelTableViewCell"
    static func nib() -> UINib {
        return UINib(nibName: "CustomChannelTableViewCell", bundle: nil)
    }
    
    func configure(with pattern: ChannelCellPattern) {
        self.labelName.textColor = pattern.theme.getCurrentFontColor()
        self.labelDate.textColor = pattern.theme.getCurrentFontColor()
        self.labelMessage.textColor = pattern.theme.getCurrentFontColor()
        self.contentView.backgroundColor = pattern.theme.getCurrentBackgroundColor()
        self.backgroundColor = pattern.theme.getCurrentBackgroundColor()
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.clear
        selectedBackgroundView = backgroundView
        
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
    }
}
