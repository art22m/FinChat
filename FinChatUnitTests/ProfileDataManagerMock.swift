//
//  ProfileDataManagerMock.swift
//  FinChatUnitTests
//
//  Created by Артём Мурашко on 06.05.2021.
//

@testable import FinChat
import Foundation

final class ProfileDataManagerMock: IProfileManager {
    var callsCount: Int
    var data: CurrentData
    
    init(data: CurrentData) {
        self.data = data
        callsCount = 0
    }
    
    func saveToFile(profile: CurrentData) -> SuccessStatus {
        callsCount += 1
        self.data = profile
        return .success
    }
    
    func readFromFile() -> (CurrentData, SuccessStatus) {
        callsCount += 1
        return (data, .success)
    }
}
