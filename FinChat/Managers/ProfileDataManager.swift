//
//  UserFileManager.swift
//  FinChat
//
//  Created by Артём Мурашко on 18.03.2021.
//

import Foundation
import UIKit

class ProfileDataManager: NSObject {
    static let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    static let fileName = "UserProfile.txt"
    static let filePath = directory!.appendingPathComponent(fileName)

    static func saveToFile(profile: WorkingData) -> SuccessStatus {
            var dataDictionary: [String: String] = [:]
        
            if let userName = profile.nameFromProfile {
                dataDictionary["userName"] = userName
            }
        
            if let userDescription = profile.descriptionFromProfile {
                dataDictionary["aboutUser"] = userDescription
            }
        
            if let userImage = profile.imageFromProfile {
                dataDictionary["userImage"] = userImage.pngData()?.base64EncodedString()
            }

            do {
                let jsonDataToSave = try JSONSerialization.data(withJSONObject: dataDictionary, options: .init(rawValue: 0))
                try jsonDataToSave.write(to: filePath, options: [])
                return SuccessStatus.success
            } catch {
                print(error.localizedDescription)
                return SuccessStatus.error
            }
        }


    static func readFromFile() -> (WorkingData, SuccessStatus) {
        do {
            let loadData = try Data(contentsOf: filePath)
            let jsonLoadData = try JSONSerialization.jsonObject(with: loadData, options: .mutableLeaves)
            
            if let userDictionary = jsonLoadData as? [String: String] {
                let dataFromFile = WorkingData()
                
                dataFromFile.nameFromFile = userDictionary["userName"]
                dataFromFile.descriptionFromFile = userDictionary["aboutUser"]

                if let imageURL = userDictionary["userImage"] {
                    let data = Data(base64Encoded: imageURL)
                    dataFromFile.imageFromFile = UIImage(data: data!)
                } else {
                    dataFromFile.imageFromFile = UIImage(named: "avatarPlaceholder")
                }
                
                return (dataFromFile, SuccessStatus.success)
            } else {
                return (WorkingData(), SuccessStatus.error)
            }
        } catch {
            return (WorkingData(), SuccessStatus.error)
        }
    }
    
}

enum SuccessStatus {
    case success
    case error
}
