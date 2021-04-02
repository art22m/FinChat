//
//  ConversationsListViewController.swift
//  FinChat
//
//  Created by Артём Мурашко on 27.02.2021.
//

import UIKit
import Firebase

protocol ThemesDelegate: class {
    func updateTheme(_ newTheme: VCTheme.Theme)
}

struct Channel {
    let identifier: String
    let name: String
    let lastMessage: String?
    let lastActivity: Date?
}

class ConversationsListViewController: UIViewController {
    
    @IBOutlet weak var buttonProfile: UIBarButtonItem!
    @IBOutlet weak var buttonSettings: UIBarButtonItem!
    @IBOutlet weak var buttonAdd: UIBarButtonItem!
    @IBOutlet weak var tableViewConversations: UITableView!
    
    @IBAction func addTapped(_ sender: Any) {
        self.present(alertAdd, animated: true)
    }
    
    let alertAdd = UIAlertController(title: "Channel", message: "Add channel", preferredStyle: .alert)
    
    // Initialize variable theme of class VCTheme() to change the theme of the screen
    var theme = VCTheme()
    
    private var channels = [Channel]()
    private lazy var db = Firestore.firestore()
    private lazy var reference = db.collection("channels")
    
    let coreDataStack = CoreDataStack()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        fetchData()
        
        alertAdd.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alertAdd.addAction(UIAlertAction(title: "Add", style: .default, handler: { [self] action in
            addChannel()
        }))
        alertAdd.addTextField()
        alertAdd.textFields![0].placeholder = "Enter name of the channel"
        
        coreDataStack.didUpdateDataBase = { stack in
            stack.printDatabaseStatistics()
        }
        coreDataStack.enableObservers()
        
        // Change color of Bar Buttons
        buttonSettings.tintColor = theme.getCurrentFontColor()
        buttonProfile.tintColor = theme.getCurrentFontColor()
        buttonAdd.tintColor = theme.getCurrentFontColor()
        
        // Initialize the table
        tableViewConversations.register(CustomConversationListTableViewCell.nib(), forCellReuseIdentifier: CustomConversationListTableViewCell.identifier)
        tableViewConversations.delegate = self
        tableViewConversations.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableViewConversations.reloadData()
    }
    
    private func addChannel() {
        if (alertAdd.textFields![0].text == "") {
            print("Empty name")
            return
        }
        
        let channelName = alertAdd.textFields![0].text
        
        reference.addDocument(data: ["name" : channelName ?? ""])
    }
    
    private func fetchData() {
        db.collection("channels").addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("No channels")
                return
            }
            
            self.channels = documents.map{ (queryDocumentSnapshot) -> Channel in
                let data = queryDocumentSnapshot.data()
                
                let id = queryDocumentSnapshot.documentID
                let name = data["name"] as? String ?? "No name"
                let lastMessage = data["lastMessage"] as? String? ?? nil
                let lastActivityTimeStamp = data["lastActivity"] as? Timestamp? ?? nil
                let lastActivity = lastActivityTimeStamp?.dateValue()
                
                return Channel(identifier: id, name: name, lastMessage: lastMessage, lastActivity: lastActivity)
            }
            
            self.channels.sort { (Channel1, Channel2) -> Bool in
                Channel1.lastActivity ?? Date.init() > Channel2.lastActivity ?? Date.init()
            }
            
            self.saveDB()
            self.tableViewConversations.reloadData()
        }
    }
    
    // Save Channels and Messages to Data Base
    private func saveDB() {
        for channelFB in channels {
            self.coreDataStack.performSave{ context in
                
                let referenceToMessages = self.db.collection("channels").document(channelFB.identifier).collection("messages")
                
                let channelDB = Channel_db(name: channelFB.name, identifier: channelFB.identifier, lastActivity: channelFB.lastActivity ?? Date.init(), lastMessage: channelFB.lastMessage ?? "", in: context)

                referenceToMessages.addSnapshotListener { (querySnapshot, error) in
                    guard let documents = querySnapshot?.documents else {
                        print("No messages")
                        return
                    }
                    
                    documents.forEach { document in
                        let content = document.data()["content"] as? String
                        let createdTimeStamp = document.data()["created"] as? Timestamp
                        let created = createdTimeStamp?.dateValue()
                        let senderId = document.data()["senderId"] as? String
                        let senderName = document.data()["senderName"] as? String
                        let messageId = document.documentID

                        let message = Message_db(content: content ?? "", created: created ?? Date.init(), messageId: messageId, senderId: senderId ?? "", senderName: senderName ?? "", in: context)

                        channelDB.addToMessages(message)
                    }
                }
            }
        }
    }
    
}

extension ConversationsListViewController: UITableViewDataSource, UITableViewDelegate {    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return channels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CustomConversationListTableViewCell.identifier, for: indexPath) as? CustomConversationListTableViewCell else { return UITableViewCell() }
        
        
        let channel = channels[indexPath.row]
        cell.configure(with: .init(identifier: channel.identifier, name: channel.name, message: channel.lastMessage, date: channel.lastActivity, theme: theme))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.performSegue(withIdentifier: "ShowConversation", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? ConversationViewController {
            destination.theme.currentTheme = self.theme.currentTheme
            guard let indexPath = tableViewConversations.indexPathForSelectedRow else { return }
            destination.title = channels[indexPath.row].name
            destination.identifierOfChannel = channels[indexPath.row].identifier
            
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
        buttonAdd.tintColor = theme.getCurrentFontColor()
        
        tableViewConversations.reloadData()
    }
}
