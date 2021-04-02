//
//  ConversationViewController.swift
//  FinChat
//
//  Created by Артём Мурашко on 02.03.2021.
//

import UIKit
import Firebase

struct Message {
    let content: String
    let created: Date
    let senderId: String
    let senderName: String
}

class ConversationViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var messageInput: UITextField!
    @IBOutlet weak var tableViewMessages: UITableView!
    @IBOutlet weak var sendButton: UIButton!
    
    @IBAction func sendTapped(_ sender: Any) {
        sendMessage()
        messageInput.text = ""
    }
    
    private var dataManagerGCD: DataManager = GCDDataManager()
    
    // Initialize variable theme of class VCTheme() to change the theme of the screen
    var theme = VCTheme()
    
    var identifierOfChannel: String = ""
    var nameOfChannel: String = ""
    var dateOfChannel: Date? = Date.init()
    var lastMessage: String? = ""
    
    var name: String = "" // Name of the user
    
    var coreDataStack = CoreDataStack()
    
    private let uniqueID = UIDevice.current.identifierForVendor?.uuidString
    private var messages = [Message]()
    private lazy var db = Firestore.firestore()
    private lazy var reference = db.collection("channels")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchMessages()
        updateName()
        self.hideKeyboardWhenTappedAround()
        
        view.backgroundColor = theme.getCurrentBackgroundColor()
        tableViewMessages.backgroundColor = theme.getCurrentBackgroundColor()
        
        let origImage = UIImage(named: "sendMessageIcon")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        sendButton.setImage(tintedImage, for: .normal)
        sendButton.tintColor = theme.getCurrentFontColor()
        
        coreDataStack.didUpdateDataBase = { stack in
            stack.printDatabaseStatistics()
        }
        coreDataStack.enableObservers()
        
        messageInput.textColor = theme.getCurrentFontColor()
        messageInput.backgroundColor = theme.getCurrentIncomeColor()
        messageInput.returnKeyType = .done
        messageInput.delegate = self
        messageInput.borderStyle = .none
        messageInput.layer.borderWidth = 1
        messageInput.layer.cornerRadius = 12

        tableViewMessages.register(CustomConversationIncomeTableViewCell.self, forCellReuseIdentifier: "id1")
        tableViewMessages.register(CustomConversationOutcomeTableViewCell.self, forCellReuseIdentifier: "id2")
        tableViewMessages.delegate = self
        tableViewMessages.dataSource = self
        
    }
    
//    func prr() {
//        coreDataStack.mainContext.perform {
//            do {
//                let count = try self.coreDataStack.mainContext.count(for: Channel_db.fetchRequest())
//                print("\n-----------------\n")
//                print("\(count) channels")
//                let array = try self.coreDataStack.mainContext.fetch(Channel_db.fetchRequest()) as? [Channel_db] ?? []
//                for ch in array {
//                    print(ch.getInfo)
//                }
//            } catch {
//                fatalError(error.localizedDescription)
//            }
//        }
//    }
    
    // Dismiss keyboard when tap on done
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        messageInput.resignFirstResponder()
        return true
    }
    
    private func updateName() {
        dataManagerGCD.readData(isSuccessful: { (profile, responce) in
            if responce == SuccessStatus.success {
                DispatchQueue.main.async(execute: {
                    self.name = profile.nameFromFile ?? ""
                })
            }
        })
    }
    
    private func sendMessage() {
        if (messageInput.text == "") {
            return
        }
        
        let content = messageInput.text
        let created = Date.init()
        let senderId = uniqueID
        let senderName = name
        reference.document(identifierOfChannel).collection("messages").addDocument(data: ["content": content ?? "", "created": created, "senderId": senderId ?? "", "senderName": senderName])
    }

    private func fetchMessages() {
        db.collection("channels").document(identifierOfChannel).collection("messages").addSnapshotListener { (querySnapshot, error) in
            
            guard let documents = querySnapshot?.documents else {
                print("No channels")
                return
            }
            
            self.messages = documents.map{ (queryDocumentSnapshot) -> Message in
                let data = queryDocumentSnapshot.data()
                
                let content = data["content"] as? String
                let createdTimeStamp = data["created"] as? Timestamp
                let created = createdTimeStamp?.dateValue()
                let senderId = data["senderId"] as? String
                let senderName = data["senderName"] as? String
                let messageId = queryDocumentSnapshot.documentID
                    
                self.coreDataStack.performSave{ context in
                    let messageDB = Message_db(content: content ?? "", created: created ?? Date.init(), messageId: messageId, senderId: senderId ?? "", senderName: senderName ?? "", in: context)
                    
                    let channelDB = Channel_db(name: self.nameOfChannel, identifier: self.identifierOfChannel, lastActivity: self.dateOfChannel ?? Date.init(), lastMessage: self.lastMessage ?? "", in: context)
                    
                    channelDB.addToMessages(messageDB)
                }

                return Message(content: content ?? "", created: created ?? Date.init(), senderId: senderId ?? "", senderName: senderName ?? "")
            }
            
            self.messages.sort { (Message1, Message2) -> Bool in
                Message1.created < Message2.created
            }
        
            self.tableViewMessages.reloadData()
        }
    }
}

// Hide the keyboard then we tapped outside UITextField
extension ConversationViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(ConversationViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension ConversationViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]
        
        if message.senderId != uniqueID {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "id1", for: indexPath) as? CustomConversationIncomeTableViewCell else { return UITableViewCell() }
            cell.configure(with: .init(text: message.content, name: message.senderName, date: message.created, theme: theme))
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "id2", for: indexPath) as? CustomConversationOutcomeTableViewCell else { return UITableViewCell() }
            cell.configure(with: .init(text: message.content, name: message.senderName, date: message.created, theme: theme))
            return cell
        }
    }
    
}
