//
//  PicturesModel.swift
//  FinChat
//
//  Created by Артём Мурашко on 23.04.2021.
//

import Foundation

protocol IPicturesModel {
    func send()
    var networkDelegate: ModelDelegate? { get set }
}

protocol ModelDelegate: class {
    func setup(dataSource: [URL])
}

class PicturesModel: IPicturesModel {
    var networkService: INetworkService
    init(networkService: INetworkService) {
        self.networkService = networkService
    }
    
    var networkDelegate: ModelDelegate?    
    func send() {
        networkService.sendRequest { result in
            switch result {
                case .success(let urls):
                    DispatchQueue.main.async {
                        self.networkDelegate?.setup(dataSource: urls)
                    }
                case .failure(let error):
                    print(error.localizedDescription)
            }
        }
    }
}
