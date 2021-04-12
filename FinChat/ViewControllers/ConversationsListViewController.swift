//
//  ConversationsListViewController.swift
//  FinChat
//
//  Created by Артём Мурашко on 27.02.2021.
//

import UIKit
import Firebase
import CoreData

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
    
    let coreData = ModernCoreDataStack()
    
//    private lazy var tableViewDataSource: UITableViewDataSource = {
//        let fetchRequest: NSFetchRequest<Channel_db> = Channel_db.fetchRequest()
//        let context = coreData.persistentContainer.viewContext
//        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
//        frc.delegate = self
//        return frc
//        }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchData()
        
        alertAdd.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alertAdd.addAction(UIAlertAction(title: "Add", style: .default, handler: { [self] action in
            addChannel()
        }))
        alertAdd.addTextField()
        alertAdd.textFields![0].placeholder = "Enter name of the channel"
        
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
                
                self.coreData.persistentContainer.performBackgroundTask { context in
                    let _ = Channel_db(name: name, identifier: id, lastActivity: lastActivity ?? Date.init(), lastMessage: lastMessage ?? "", in: context)
                    
                    do {
                        context.automaticallyMergesChangesFromParent = true
                        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
                        try context.save()
                    } catch {
                        print(error)
                    }
                }
                
                return Channel(identifier: id, name: name, lastMessage: lastMessage, lastActivity: lastActivity)
            }
            
            self.channels.sort { (Channel1, Channel2) -> Bool in
                Channel1.lastActivity ?? Date.init() > Channel2.lastActivity ?? Date.init()
            }
            
            self.tableViewConversations.reloadData()
        }
    }
    
    func simpleFertchRequest() {
            print("Simple Fetch Request")
            
            let fetchRequest: NSFetchRequest<Channel_db> = Channel_db.fetchRequest()
            let objects = try! coreData.persistentContainer.viewContext.fetch(fetchRequest)
        
            print(objects.count)
            
            print("")
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

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            db.collection("channels").document(channels[indexPath.row].identifier).delete()
//            channels.remove(at: indexPath.row)
//            tableView.deleteRows(at: [indexPath], with: .fade)
            print("removed")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? ConversationViewController {
            destination.theme.currentTheme = self.theme.currentTheme
            guard let indexPath = tableViewConversations.indexPathForSelectedRow else { return }
            destination.channel = channels[indexPath.row]
            destination.title = channels[indexPath.row].name
            destination.coreData = coreData
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
