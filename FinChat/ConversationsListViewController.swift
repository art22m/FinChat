//
//  ConversationsListViewController.swift
//  FinChat
//
//  Created by Артём Мурашко on 27.02.2021.
//

import UIKit

class ConversationsListViewController: UIViewController {
    
    @IBOutlet weak var buttonProfile: UIBarButtonItem!
    @IBOutlet weak var tableViewMessages: UITableView!
    
    // Temporary structure CellModel and array listOfUsers for test
    struct CellModel {
        var name: String?
        var message: String?
        var date: Date?
        var online: Bool
        var hasUnreadMessages: Bool
    }
    
    let listOfUsers : [CellModel] = [CellModel(name: "Artem Murashko", message: "Where are you?", date: Date.init(),                                      online: true, hasUnreadMessages: true),
                                    CellModel(name: "Barack Obama", message: "What's up bro!", date: Date.init(timeIntervalSinceNow: -240), online: true, hasUnreadMessages: false),
                                    CellModel(name: "Laylah Slater", message: "Okay!", date: nil, online: true, hasUnreadMessages: true),
                                    CellModel(name: "Ella Fulton", message: "Hahaha :D", date: nil, online: true, hasUnreadMessages: false),
                                    CellModel(name: "Ayaana Church", message: nil, date: nil, online: true, hasUnreadMessages: false),
                                    CellModel(name: "Mikolaj Mcconnell", message: nil, date: nil, online: true, hasUnreadMessages: true),
                                    CellModel(name: nil, message: nil, date: nil, online: true, hasUnreadMessages: false),
                                    CellModel(name: nil, message: nil, date: nil, online: true, hasUnreadMessages: true),
                                    CellModel(name: nil, message: "Idk dude", date: Date.init(timeIntervalSinceNow: -86400), online: true, hasUnreadMessages: true),
                                    CellModel(name: "Humzah Mckay", message: nil, date: Date.init(timeIntervalSinceNow: -259200), online: true, hasUnreadMessages: false),
                                    CellModel(name: "Nafeesa Preece", message: "Who r u?", date: Date.init(timeIntervalSinceNow: -600),  online: false, hasUnreadMessages: true),
                                    CellModel(name: "Lindsay Bond", message: "Mmm. Sound's good!", date: Date.init(timeIntervalSinceNow: -1200), online: false, hasUnreadMessages: false),
                                    CellModel(name: "Nakita Raymond", message: "What was in that picture?", date: nil, online: false, hasUnreadMessages: true),
                                    CellModel(name: "Vihaan Gibbs", message: "Rly? I can't believe it! :D", date: nil, online: false, hasUnreadMessages: false),
                                    CellModel(name: "Amin Daniel", message: nil, date: nil, online: false, hasUnreadMessages: false),
                                    CellModel(name: "Menna Frazier", message: nil, date: nil, online: false, hasUnreadMessages: true),
                                    CellModel(name: nil, message: nil, date: nil, online: false, hasUnreadMessages: false),
                                    CellModel(name: nil, message: nil, date: nil, online: false, hasUnreadMessages: true),
                                    CellModel(name: nil, message: "How much is it?", date: Date.init(timeIntervalSinceNow: -86400), online: false, hasUnreadMessages: true),
                                    CellModel(name: "Yes, it's me", message: nil, date: Date.init(timeIntervalSinceNow: -259200), online: false, hasUnreadMessages: false),
    ]
    
    let headers : [String] = ["Online", "History"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Creating a table
        tableViewMessages.register(CustomConversationListTableViewCell.nib(), forCellReuseIdentifier: CustomConversationListTableViewCell.identifier)
        tableViewMessages.delegate = self
        tableViewMessages.dataSource = self
    }
}

extension ConversationsListViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return headers.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return headers[section]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // If section == 0, then return number of online users and otherwise
        return listOfUsers.filter{$0.online == (section == 0 ? true : false) }.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CustomConversationListTableViewCell.identifier, for: indexPath) as? CustomConversationListTableViewCell else { return UITableViewCell() }
        
        
        let cellModel = listOfUsers.filter{$0.online == (indexPath.section == 0 ? true : false)}[indexPath.row]
        
        cell.configure(with: .init(name: cellModel.name, message: cellModel.message, date: cellModel.date, online: cellModel.online, hasUnreadMessages: cellModel.hasUnreadMessages))
    
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }
    
}
