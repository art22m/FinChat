//
//  ConversationsListViewController.swift
//  FinChat
//
//  Created by Артём Мурашко on 27.02.2021.
//

import UIKit

protocol ThemesDelegate: class {
    func updateTheme(_ newTheme: VCTheme.Theme)
}

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
                                CellModel(name: "Laylah Slater-Dan-Jark-Man", message: "Okay!", date: nil, online: true, hasUnreadMessages: true),
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
                                CellModel(name: "Michael Lomonosov", message: nil, date: Date.init(timeIntervalSinceNow: -259200), online: false, hasUnreadMessages: false),
]

class ConversationsListViewController: UIViewController {
    
    @IBOutlet weak var buttonProfile: UIBarButtonItem!
    @IBOutlet weak var buttonSettings: UIBarButtonItem!
    @IBOutlet weak var tableViewConversations: UITableView!
    
    let headers : [String] = ["Online", "History"]
    
    // Initialize variable theme of class VCTheme() to change the theme of the screen
    var theme = VCTheme()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Change color of Bar Buttons
        buttonSettings.tintColor = theme.getCurrentFontColor()
        buttonProfile.tintColor = theme.getCurrentFontColor()
        
        // Initialize the table
        tableViewConversations.register(CustomConversationListTableViewCell.nib(), forCellReuseIdentifier: CustomConversationListTableViewCell.identifier)
        tableViewConversations.delegate = self
        tableViewConversations.dataSource = self
    }
}

extension ConversationsListViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return headers.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return headers[section]
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        // Change color of section's header
        view.tintColor = theme.currentTheme == .night ?
        theme.nightIncomeColor : theme.dayIncomeColor
        if let headerView = view as? UITableViewHeaderFooterView {
            headerView.textLabel?.textColor = theme.getCurrentFontColor()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // If section == 0, then return number of online users and otherwise
        return listOfUsers.filter{$0.online == (section == 0 ? true : false) }.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CustomConversationListTableViewCell.identifier, for: indexPath) as? CustomConversationListTableViewCell else { return UITableViewCell() }
        
        
        let cellModel = listOfUsers.filter{$0.online == (indexPath.section == 0 ? true : false)}[indexPath.row]
        
        cell.configure(with: .init(name: cellModel.name, message: cellModel.message, date: cellModel.date, online: cellModel.online, hasUnreadMessages: cellModel.hasUnreadMessages, theme: theme))
    
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.performSegue(withIdentifier: "ShowConversation", sender: self)
        
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? ConversationViewController {
            destination.theme.currentTheme = self.theme.currentTheme
            guard let indexPath = tableViewConversations.indexPathForSelectedRow else { return }
            destination.title = listOfUsers.filter{$0.online == (indexPath.section == 0 ? true : false)}[indexPath.row].name
        } else if let themesVC = segue.destination as? ThemesViewController {
            themesVC.themeDelegate = self
            themesVC.theme.currentTheme = self.theme.currentTheme
        } else if let profileVC = segue.destination as? ViewController {
            profileVC.theme.currentTheme = self.theme.currentTheme
        }
    }
}

extension ConversationsListViewController: ThemesDelegate {
    func updateTheme(_ newTheme: VCTheme.Theme) {
        theme.currentTheme = newTheme
        
        view.backgroundColor = theme.getCurrentBackgroundColor()
        
        // Change appearence of Navigation Bar
        navigationController?.navigationBar.barTintColor = theme.currentTheme == .night ? theme.nightIncomeColor : theme.classicBackgroundColor
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: theme.getCurrentFontColor()]
        
        // Change appearence of Table View
        tableViewConversations.separatorColor = theme.currentTheme == .night ? theme.nightIncomeColor : theme.classicBackgroundColor
        tableViewConversations.backgroundColor = theme.getCurrentBackgroundColor()
        
        // Change color of Bar Buttons
        buttonSettings.tintColor = theme.getCurrentFontColor()
        buttonProfile.tintColor = theme.getCurrentFontColor()
        
        tableViewConversations.reloadData()
    }
}
