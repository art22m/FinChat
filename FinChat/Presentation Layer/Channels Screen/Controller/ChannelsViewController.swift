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

class ChannelsViewController: UIViewController, NSFetchedResultsControllerDelegate {
    // MARK: - @IBOutlet
    @IBOutlet weak var buttonProfile: UIBarButtonItem!
    @IBOutlet weak var buttonSettings: UIBarButtonItem!
    @IBOutlet weak var buttonAdd: UIBarButtonItem!
    @IBOutlet weak var tableViewConversations: UITableView!
    
    // MARK: - @IBAction
    @IBAction func addTapped(_ sender: Any) {
        self.present(alertAdd, animated: true)
    }
    
    private var channels = [ChannelModel]()
    private lazy var db = Firestore.firestore()
    private let channelActions: IChannelActions = ChannelActions()
    let alertAdd = UIAlertController(title: "Channel", message: "Add channel", preferredStyle: .alert)
    let coreData = ModernCoreDataStack()
    var theme = VCTheme()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchData()
        
        self.tableViewConversations.dataSource = self.tableViewDataSource
        
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
        tableViewConversations.register(CustomChannelTableViewCell.nib(), forCellReuseIdentifier: CustomChannelTableViewCell.identifier)
        tableViewConversations.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableViewConversations.reloadData()
    }
    
    private lazy var tableViewDataSource: UITableViewDataSource = {
        let context = coreData.persistentContainer.viewContext
        let request: NSFetchRequest<Channel_db> = Channel_db.fetchRequest()
        let sortDesctiptor = NSSortDescriptor(keyPath: \Channel_db.name, ascending: false)
        request.sortDescriptors = [sortDesctiptor]
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        
        return ChannelsTableViewDataSource(fetchedResultsController: fetchedResultsController, context: context)
    }()
}

extension ChannelsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "ShowConversation", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? ChatViewController {
            destination.theme.currentTheme = self.theme.currentTheme
            guard let indexPath = tableViewConversations.indexPathForSelectedRow else { return }
            destination.currentChannel = channels[indexPath.row]
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

extension ChannelsViewController: ThemesDelegate {
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

extension ChannelsViewController {
    private func addChannel() {
        if (alertAdd.textFields![0].text == "") { return }
        let channelName = alertAdd.textFields![0].text
        
        channelActions.addChannel(channelName: channelName)
    }
    
    private func fetchData() {
        db.collection("channels").addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("No channels")
                return
            }
            
            self.channels = documents.map{ (queryDocumentSnapshot) -> ChannelModel in
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
                return ChannelModel(identifier: id, name: name, lastMessage: lastMessage, lastActivity: lastActivity)
            }
            
            self.tableViewConversations.reloadData()
        }
    }
}
