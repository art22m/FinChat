//
//  GCDManager.swift
//  FinChat
//
//  Created by Артём Мурашко on 18.03.2021.
//

import Foundation

class GCDDataManager: DataManager {
    func saveData(dataToSave: WorkingData, isSuccessful: @escaping (SuccessStatus) -> Void) {
        let globalQueue = DispatchQueue.global(qos: .utility)
        globalQueue.async {
            let status = ProfileDataManager.saveToFile(profile: dataToSave)
            isSuccessful(status)
        }
    }
    
    func readData(isSuccessful: @escaping ((WorkingData, SuccessStatus)) -> Void) {
        let globalQueue = DispatchQueue.global(qos: .utility)
        globalQueue.async {
            let status: (WorkingData, SuccessStatus) = ProfileDataManager.readFromFile()
            isSuccessful(status)
        }
    }
}
