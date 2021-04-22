//
//  ChannelsTableDataSource.swift
//  FinChat
//
//  Created by Артём Мурашко on 16.04.2021.
//

import UIKit
import CoreData
import Firebase

class ChannelsTableViewDataSource: NSObject, UITableViewDataSource {
    let fetchedResultsController: NSFetchedResultsController<Channel_db>
    let context: NSManagedObjectContext
    var theme = VCTheme()
    
    init(fetchedResultsController: NSFetchedResultsController<Channel_db>, context: NSManagedObjectContext) {
        self.fetchedResultsController = fetchedResultsController
        self.context = context
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("Error fetching data: \(error)")
        }
    }
    
    public func updateData() {
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("Error fetching data: \(error)")
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        updateData()
//        guard let sections = self.fetchedResultsController.sections else {
//            fatalError("No sections")
//        }
//        let sectionInfo = sections[section]
        return ChannelsViewController.channels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        updateData()
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CustomChannelTableViewCell.identifier, for: indexPath) as? CustomChannelTableViewCell else { return UITableViewCell() }
        
//        let channel = self.fetchedResultsController.object(at: indexPath)
        let channel = ChannelsViewController.channels[indexPath.row]
        cell.configure(with: .init(identifier: channel.identifier , name: channel.name, message: channel.lastMessage, date: channel.lastActivity))
        
        return cell
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let db = Firestore.firestore()
            guard let id = self.fetchedResultsController.object(at: indexPath).identifier else { return }
            db.collection("channels").document(id).delete()
            self.context.delete(self.fetchedResultsController.object(at: indexPath))
            print("removed")
            updateData()
        }
    }
}
