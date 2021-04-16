//
//  GCDManager.swift
//  FinChat
//
//  Created by Артём Мурашко on 18.03.2021.
//

import Foundation

protocol IDataManager {
    func saveData(dataToSave: CurrentData, isSuccessful: @escaping (SuccessStatus) -> Void)
    func readData(isSuccessful: @escaping ((CurrentData, SuccessStatus)) -> Void)
}

class GCDDataManager: IDataManager {
    func saveData(dataToSave: CurrentData, isSuccessful: @escaping (SuccessStatus) -> Void) {
        let globalQueue = DispatchQueue.global(qos: .utility)
        globalQueue.async {
            let status = ProfileDataManager.saveToFile(profile: dataToSave)
            isSuccessful(status)
        }
    }
    
    func readData(isSuccessful: @escaping ((CurrentData, SuccessStatus)) -> Void) {
        let globalQueue = DispatchQueue.global(qos: .utility)
        globalQueue.async {
            let status: (CurrentData, SuccessStatus) = ProfileDataManager.readFromFile()
            isSuccessful(status)
        }
    }
}
