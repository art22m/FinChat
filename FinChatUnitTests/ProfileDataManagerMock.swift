//
//  ProfileDataManagerMock.swift
//  FinChatUnitTests
//
//  Created by Артём Мурашко on 06.05.2021.
//

@testable import FinChat
import Foundation

final class ProfileDataManagerMock: IProfileManager {
    static func saveToFile(profile: CurrentData) -> SuccessStatus {
        <#code#>
    }
    
    static func readFromFile() -> (CurrentData, SuccessStatus) {
        <#code#>
    }
}
