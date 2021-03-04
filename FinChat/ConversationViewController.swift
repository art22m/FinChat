//
//  ConversationViewController.swift
//  FinChat
//
//  Created by Артём Мурашко on 02.03.2021.
//

import UIKit

// Temporary structure MessageModel and array listOfMessages for test
struct MessageModel {
    var message: String?
    var isIncome: Bool
}

let listOfMessages: [MessageModel] = [MessageModel(message: "Hello, how r you? Haven't seen you for a long time, how is your poem?", isIncome: true),
                                      MessageModel(message: "I'm fine, thanks! You should read my excerpt of the poem! Do you want it?", isIncome: false), MessageModel(message: "Yes, of course!", isIncome: true), MessageModel(message: """
                                        She walks in Beauty, like the night
                                        Of cloudless climes and starry skies;
                                        And all that's best of dark and bright
                                        Meet in her aspect and her eyes:
                                        Thus mellowed to that tender light
                                        Which Heaven to gaudy day denies.
                                        """, isIncome: false), MessageModel(message: "What do u think about this? :D", isIncome: false)]

class ConversationViewController: UIViewController {

    @IBOutlet weak var messageInput: UITextView!
    @IBOutlet weak var tableViewMessages: UITableView!
       
    override func viewDidLoad() {
        super.viewDidLoad()
        
        messageInput.layer.cornerRadius = 16
        messageInput.layer.borderWidth = 1

        tableViewMessages.register(CustomConversationIncomeTableViewCell.self, forCellReuseIdentifier: "id1")
        tableViewMessages.register(CustomConversationOutcomeTableViewCell.self, forCellReuseIdentifier: "id2")
        tableViewMessages.delegate = self
        tableViewMessages.dataSource = self
        
    }
}

extension ConversationViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listOfMessages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let messageModel = listOfMessages[indexPath.row]
        
        if messageModel.isIncome == true {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "id1", for: indexPath) as? CustomConversationIncomeTableViewCell else { return UITableViewCell() }
            cell.configure(with: .init(text: messageModel.message))
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "id2", for: indexPath) as? CustomConversationOutcomeTableViewCell else { return UITableViewCell() }
            cell.configure(with: .init(text: messageModel.message))
            return cell
        }
    }
    
}
