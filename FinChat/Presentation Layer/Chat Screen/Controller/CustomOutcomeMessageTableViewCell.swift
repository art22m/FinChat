//
//  CustomChatOutcomeTableViewCell.swift
//  FinChat
//
//  Created by Артём Мурашко on 16.04.2021.
//

import UIKit

class CustomOutcomeMessageTableViewCell: UITableViewCell {
    let labelDate = UILabel()
    let labelOutcomeMessage = UILabel()
    let viewOutcomeMessageBackground = UIView()
    
    static let identifier = "CustomConversationOutcomeTableViewCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            
            addSubview(viewOutcomeMessageBackground)
            viewOutcomeMessageBackground.layer.cornerRadius = 14
            viewOutcomeMessageBackground.translatesAutoresizingMaskIntoConstraints = false
            
            addSubview(labelOutcomeMessage)
            labelOutcomeMessage.numberOfLines = 0
            labelOutcomeMessage.translatesAutoresizingMaskIntoConstraints = false
        
            addSubview(labelDate)
            labelDate.translatesAutoresizingMaskIntoConstraints = false
        
            // Constraints for Income message and background view
            let messageConstraints = [labelOutcomeMessage.topAnchor.constraint(equalTo: topAnchor, constant: 32),
                                      labelOutcomeMessage.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32),
                                      labelOutcomeMessage.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -32),
                                      labelOutcomeMessage.widthAnchor.constraint(lessThanOrEqualTo: widthAnchor, multiplier: 0.75, constant: -64),
                                      
                                      labelDate.topAnchor.constraint(equalTo: labelOutcomeMessage.bottomAnchor, constant: 10),
                                      labelDate.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32),
                                      labelDate.widthAnchor.constraint(lessThanOrEqualTo: widthAnchor, multiplier: 0.75, constant: -64),
                                      
                                      viewOutcomeMessageBackground.topAnchor.constraint(equalTo: labelOutcomeMessage.topAnchor, constant: -16),
                                      viewOutcomeMessageBackground.leadingAnchor.constraint(equalTo: labelOutcomeMessage.leadingAnchor, constant: -16),
                                      viewOutcomeMessageBackground.leadingAnchor.constraint(equalTo: labelDate.leadingAnchor, constant: -16),
                                      viewOutcomeMessageBackground.bottomAnchor.constraint(equalTo: labelDate.bottomAnchor, constant: 16),
                                      viewOutcomeMessageBackground.trailingAnchor.constraint(equalTo: labelOutcomeMessage.trailingAnchor, constant: 16),
                                      viewOutcomeMessageBackground.trailingAnchor.constraint(equalTo: labelDate.trailingAnchor, constant: 16),
                                      ]
        
            sendSubviewToBack(contentView)
            NSLayoutConstraint.activate(messageConstraints)
        }
        
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with pattern: MessageCellPattern) {
        if let text = pattern.text {
            self.labelOutcomeMessage.text = text
        } else {
            self.labelOutcomeMessage.text = ""
        }
        
        // Change the appearence of the cells
        backgroundColor = pattern.theme.getCurrentBackgroundColor()
        
        labelOutcomeMessage.textColor = pattern.theme.getCurrentFontColor()
        viewOutcomeMessageBackground.backgroundColor = pattern.theme.getCurrentOutcomeColor()
        labelDate.textColor = pattern.theme.getCurrentFontColor()
        
        let calendar = NSCalendar.autoupdatingCurrent
        let formatter = DateFormatter()
        formatter.dateFormat = calendar.isDateInToday(pattern.date) ? "HH:mm" : "dd MMM"
        
        labelDate.text = formatter.string(from: pattern.date)
        labelDate.font = UIFont.italicSystemFont(ofSize:UIFont.labelFontSize)
    }
}
