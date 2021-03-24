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

let listOfUsers : [CellModel] = []

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
        } else if let profileVC = segue.destination as? ProfileViewController {
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
