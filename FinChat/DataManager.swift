//
//  DataManager.swift
//  FinChat
//
//  Created by Артём Мурашко on 18.03.2021.
//

import Foundation

protocol DataManager {
    func saveData(dataToSave: WorkingData, isSuccessful: @escaping (SuccessStatus) -> Void)
    func readData(isSuccessful: @escaping ((WorkingData, SuccessStatus)) -> Void)
}

