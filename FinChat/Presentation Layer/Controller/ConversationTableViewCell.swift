//
//  CustomConversationTableViewCell.swift
//  FinChat
//
//  Created by Артём Мурашко on 03.03.2021.
//

import UIKit

protocol MessageCellConfiguration: class {
    var text : String? {get set}
    var date : Date {get set}
    var name : String {get set}
    var theme : VCTheme {get set}
}

class CustomConversationIncomeTableViewCell: UITableViewCell {
    let labelDate = UILabel()
    let labelName = UILabel()
    let labelIncomeMessage = UILabel()
    let viewIncomeMessageBackground = UIView()
    
    static let identifier = "CustomConversationIncomeTableViewCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            
            addSubview(viewIncomeMessageBackground)
            viewIncomeMessageBackground.layer.cornerRadius = 14
            viewIncomeMessageBackground.translatesAutoresizingMaskIntoConstraints = false
            
            addSubview(labelIncomeMessage)
            labelIncomeMessage.numberOfLines = 0
            labelIncomeMessage.translatesAutoresizingMaskIntoConstraints = false
            
        
            addSubview(labelName)
            labelName.numberOfLines = 1
            labelName.translatesAutoresizingMaskIntoConstraints = false
        
            addSubview(labelDate)
            labelDate.translatesAutoresizingMaskIntoConstraints = false
        
            // Constraints for Income message and background view
        let messageConstraints = [labelName.topAnchor.constraint(equalTo: topAnchor, constant: 32),
                                  labelName.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32),
                                  labelName.widthAnchor.constraint(lessThanOrEqualTo: widthAnchor, multiplier: 0.75, constant: -64),
                                  
                                  labelIncomeMessage.topAnchor.constraint(equalTo: labelName.bottomAnchor, constant: 10),
                                  labelIncomeMessage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32),
                                  labelIncomeMessage.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -32),
                                  labelIncomeMessage.widthAnchor.constraint(lessThanOrEqualTo: widthAnchor, multiplier: 0.75, constant: -64),
                                  
                                  labelDate.topAnchor.constraint(equalTo: labelIncomeMessage.bottomAnchor, constant: 10),
                                  labelDate.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32),
                                  labelDate.widthAnchor.constraint(lessThanOrEqualTo: widthAnchor, multiplier: 0.75, constant: -64),
                                  
                                  viewIncomeMessageBackground.topAnchor.constraint(equalTo: labelName.topAnchor, constant: -16),
                                  viewIncomeMessageBackground.leadingAnchor.constraint(equalTo: labelName.leadingAnchor, constant: -16),
                                  viewIncomeMessageBackground.bottomAnchor.constraint(equalTo: labelDate.bottomAnchor, constant: 16),
                                  viewIncomeMessageBackground.trailingAnchor.constraint(equalTo: labelIncomeMessage.trailingAnchor, constant: 16),
                                  viewIncomeMessageBackground.trailingAnchor.constraint(equalTo: labelName.trailingAnchor, constant: 16),
                                  viewIncomeMessageBackground.trailingAnchor.constraint(equalTo: labelDate.trailingAnchor, constant: 16),
                                  ]
        
            sendSubviewToBack(contentView)
            NSLayoutConstraint.activate(messageConstraints)
        }
        
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    class Model : MessageCellConfiguration {
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
    
    func configure(with pattern: Model) {
        if let text = pattern.text {
            labelIncomeMessage.text = text
        } else {
            self.labelIncomeMessage.text = ""
        }
        
        let calendar = NSCalendar.autoupdatingCurrent
        let formatter = DateFormatter()
        formatter.dateFormat = calendar.isDateInToday(pattern.date) ? "HH:mm" : "dd MMM"
        
        // Change the appearence of the cells
        backgroundColor = pattern.theme.getCurrentBackgroundColor()
        labelIncomeMessage.textColor = pattern.theme.getCurrentFontColor()
        viewIncomeMessageBackground.backgroundColor = pattern.theme.getCurrentIncomeColor()
        labelName.textColor = pattern.theme.getCurrentFontColor()
        labelDate.textColor = pattern.theme.getCurrentFontColor()
        
        labelName.text = pattern.name
        labelName.font = UIFont.boldSystemFont(ofSize:UIFont.labelFontSize)
        
        labelDate.text = formatter.string(from: pattern.date)
        labelDate.font = UIFont.italicSystemFont(ofSize:UIFont.labelFontSize)
    }
}

class CustomConversationOutcomeTableViewCell: UITableViewCell {
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
    
    class Model : MessageCellConfiguration {
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
    
    func configure(with pattern: Model) {
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
