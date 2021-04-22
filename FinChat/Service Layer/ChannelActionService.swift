//
//  ChannelActionService.swift
//  FinChat
//
//  Created by Артём Мурашко on 16.04.2021.
//

import Foundation
import Firebase

protocol IChannelActions: class {
    func addChannel(channelName: String?)
}

class ChannelActions: IChannelActions {
    private lazy var db = Firestore.firestore()
 
    func addChannel (channelName: String?) {
        db.collection("channels").addDocument(data: ["name" : channelName ?? ""])
    }
}
