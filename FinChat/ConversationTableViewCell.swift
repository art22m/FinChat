//
//  CustomConversationTableViewCell.swift
//  FinChat
//
//  Created by Артём Мурашко on 03.03.2021.
//

import UIKit

protocol MessageCellConfiguration : class {
    var text : String? {get set}
}

class CustomConversationIncomeTableViewCell: UITableViewCell {
    
    let labelIncomeMessage = UILabel()
    let viewIncomeMessageBackground = UIView()
    
    static let identifier = "CustomConversationIncomeTableViewCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            
            addSubview(viewIncomeMessageBackground)
            viewIncomeMessageBackground.backgroundColor = UIColor(red: 233.0/255.0, green: 232.0/255.0, blue: 55.0/255.0, alpha: 1.0)
            viewIncomeMessageBackground.layer.cornerRadius = 14
            viewIncomeMessageBackground.translatesAutoresizingMaskIntoConstraints = false
            
            addSubview(labelIncomeMessage)
            labelIncomeMessage.numberOfLines = 0
            labelIncomeMessage.translatesAutoresizingMaskIntoConstraints = false
            
            // Constraints for Income message and background view
            let messageConstraints = [labelIncomeMessage.topAnchor.constraint(equalTo: topAnchor, constant: 32),
                                      labelIncomeMessage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32),
                                      labelIncomeMessage.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -32),
                                      labelIncomeMessage.widthAnchor.constraint(lessThanOrEqualTo: widthAnchor, multiplier: 0.75, constant: -64),
                                      
                                      viewIncomeMessageBackground.topAnchor.constraint(equalTo: labelIncomeMessage.topAnchor, constant: -16),
                                      viewIncomeMessageBackground.leadingAnchor.constraint(equalTo: labelIncomeMessage.leadingAnchor, constant: -16),
                                      viewIncomeMessageBackground.bottomAnchor.constraint(equalTo: labelIncomeMessage.bottomAnchor, constant: 16),
                                      viewIncomeMessageBackground.trailingAnchor.constraint(equalTo: labelIncomeMessage.trailingAnchor, constant: 16),
                                      ]
            
            NSLayoutConstraint.activate(messageConstraints)
        }
        
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    class Model : MessageCellConfiguration {
        var text: String?
        
        init(text: String?) {
            self.text = text
        }
    }
    
    func configure(with pattern: Model) {
        if let text = pattern.text {
            labelIncomeMessage.text = text
        }
    }
}

class CustomConversationOutcomeTableViewCell: UITableViewCell {
    
    let labelOutcomeMessage = UILabel()
    let viewOutcomeMessageBackground = UIView()
    
    static let identifier = "CustomConversationOutcomeTableViewCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            
            addSubview(viewOutcomeMessageBackground)
        viewOutcomeMessageBackground.backgroundColor = .lightGray
            viewOutcomeMessageBackground.layer.cornerRadius = 14
            viewOutcomeMessageBackground.translatesAutoresizingMaskIntoConstraints = false
            
            addSubview(labelOutcomeMessage)
            labelOutcomeMessage.numberOfLines = 0
            labelOutcomeMessage.translatesAutoresizingMaskIntoConstraints = false
            
            // Constraints for Income message and background view
            let messageConstraints = [labelOutcomeMessage.topAnchor.constraint(equalTo: topAnchor, constant: 32),
                                      labelOutcomeMessage.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32),
                                      labelOutcomeMessage.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -32),
                                      labelOutcomeMessage.widthAnchor.constraint(lessThanOrEqualTo: widthAnchor, multiplier: 0.75, constant: -64),
                                      
                                      viewOutcomeMessageBackground.topAnchor.constraint(equalTo: labelOutcomeMessage.topAnchor, constant: -16),
                                      viewOutcomeMessageBackground.leadingAnchor.constraint(equalTo: labelOutcomeMessage.leadingAnchor, constant: -16),
                                      viewOutcomeMessageBackground.bottomAnchor.constraint(equalTo: labelOutcomeMessage.bottomAnchor, constant: 16),
                                      viewOutcomeMessageBackground.trailingAnchor.constraint(equalTo: labelOutcomeMessage.trailingAnchor, constant: 16),
                                      ]
            
            NSLayoutConstraint.activate(messageConstraints)
        }
        
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    class Model : MessageCellConfiguration {
        var text: String?
        
        init(text: String?) {
            self.text = text
        }
    }
    
    func configure(with pattern: Model) {
        if let text = pattern.text {
            self.labelOutcomeMessage.text = text
        } else {
            self.labelOutcomeMessage.text = ""
        }
    }
}



