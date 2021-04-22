//
//  InitialData.swift
//  FinChat
//
//  Created by Артём Мурашко on 16.04.2021.
//

import Foundation
import UIKit

class InitialData {
    var initialTextFieldName: String?
    var initialTextFieldDescription: String?
    var initialAvatarImage: UIImage?
    
    init() {
        initialTextFieldName = ""
        initialTextFieldDescription = ""
        initialAvatarImage = UIImage(named: "avatarPlaceholder")
    }
}
