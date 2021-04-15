//
//  ConversationViewController.swift
//  FinChat
//
//  Created by Артём Мурашко on 02.03.2021.
//

import UIKit
import Firebase
import CoreData

class ChatViewController: UIViewController, UITextFieldDelegate {
    // MARK: - @IBOutlet
    @IBOutlet weak var messageInput: UITextField!
    @IBOutlet weak var tableViewMessages: UITableView!
    @IBOutlet weak var sendButton: UIButton!
    
    private let uniqueID = UIDevice.current.identifierForVendor?.uuidString
    private var dataManagerGCD: DataManager = GCDDataManager()
    private lazy var db = Firestore.firestore()
    private var messages = [MessageModel]()
    private var nameFromProfile: String = ""
    
    var theme = VCTheme()
    var coreData = ModernCoreDataStack()
    var currentChannel = ChannelModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchMessages()
        updateName()
        hideKeyboardWhenTappedAround()
        
        view.backgroundColor = theme.getCurrentBackgroundColor()
        tableViewMessages.backgroundColor = theme.getCurrentBackgroundColor()
        
        let origImage = UIImage(named: "sendMessageIcon")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        sendButton.setImage(tintedImage, for: .normal)
        sendButton.tintColor = theme.getCurrentFontColor()
        
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
    
    // MARK: - @IBActions
    @IBAction func sendTapped(_ sender: Any) {
        sendMessage()
        messageInput.text = ""
    }
}

extension ChatViewController {
    private func updateName() {
        dataManagerGCD.readData(isSuccessful: { (profile, responce) in
            if responce == SuccessStatus.success {
                DispatchQueue.main.async(execute: {
                    self.nameFromProfile = profile.nameFromFile ?? ""
                })
            }
        })
    }
    
    private func sendMessage() {
        if (messageInput.text == "") { return }
        db.collection("channels").document(currentChannel.identifier).collection("messages").addDocument(data: ["content": messageInput.text ?? "", "created": Date.init(), "senderId": uniqueID ?? "", "senderName": nameFromProfile])
    }

    private func fetchMessages() {
        db.collection("channels").document(currentChannel.identifier).collection("messages").addSnapshotListener { (querySnapshot, error) in
            
            guard let documents = querySnapshot?.documents else {
                print("No channels")
                return
            }
            
            self.messages = documents.map{ (queryDocumentSnapshot) -> MessageModel in
                let data = queryDocumentSnapshot.data()
                
                let content = data["content"] as? String
                let createdTimeStamp = data["created"] as? Timestamp
                let created = createdTimeStamp?.dateValue()
                let senderId = data["senderId"] as? String
                let senderName = data["senderName"] as? String
                let messageId = queryDocumentSnapshot.documentID
                
                self.coreData.persistentContainer.performBackgroundTask { context in
                    let messageDB = Message_db(content: content ?? "", created: created ?? Date.init(), messageId: messageId, senderId: senderId ?? "", senderName: senderName ?? "", in: context)
                    
                    let channelDB = Channel_db(name: self.currentChannel.name, identifier: self.currentChannel.identifier, lastActivity: self.currentChannel.lastActivity ?? Date.init(), lastMessage: self.currentChannel.lastMessage ?? "", in: context)
                    
                    channelDB.addToMessages(messageDB)
                    
                    do {
                        context.automaticallyMergesChangesFromParent = true
                        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
                        try context.save()
                    } catch {
                        print(error)
                    }
                }

                return MessageModel(content: content ?? "", created: created ?? Date.init(), senderId: senderId ?? "", senderName: senderName ?? "")
            }
            
            self.messages.sort { (Message1, Message2) -> Bool in
                Message1.created < Message2.created
            }
        
            self.tableViewMessages.reloadData()
            self.scrollToBottom()
        }
    }
}

// MARK: -Keyboard
/*
 Hide the keyboard then we tapped outside UITextField
 */
extension ChatViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(ChatViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // Dismiss keyboard when tap on done
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        messageInput.resignFirstResponder()
        return true
    }
    
    func scrollToBottom() {
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: self.messages.count-1, section: 0)
            if (self.messages.count != 0) {
                self.tableViewMessages.scrollToRow(at: indexPath, at: .bottom, animated: true)
            }
        }
    }
}

extension ChatViewController: UITableViewDelegate, UITableViewDataSource {
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
