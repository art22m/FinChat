//
//  OperationManager.swift
//  FinChat
//
//  Created by Артём Мурашко on 18.03.2021.
//

import Foundation

class OperationDataManager: DataManager {
    func saveData(dataToSave: WorkingData, isSuccessful: @escaping (SuccessStatus) -> Void) {
        let customQueue = OperationQueue()
        customQueue.addOperation({
            print("Save Operation")
            let status = ProfileDataManager.saveToFile(profile: dataToSave)
            isSuccessful(status)
        })
    }

    func readData(isSuccessful: @escaping ((WorkingData, SuccessStatus)) -> Void) {
        let customQueue = OperationQueue()

        customQueue.addOperation({
            print("Read Operation")
            let status: (WorkingData, SuccessStatus) = ProfileDataManager.readFromFile()
            isSuccessful(status)
        })
    }
}
