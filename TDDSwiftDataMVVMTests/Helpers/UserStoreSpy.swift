//
//  UserStoreSpy.swift
//  TDDSwiftDataMVVM
//
//  Created by Mushthak Ebrahim on 14/12/24.
//
import TDDSwiftDataMVVM

class UserStoreSpy: UserStore {
    enum ReceivedMessage {
        case retrieve
    }
    
    enum Error: Swift.Error {
        case retrievalError
    }
    
    private(set) var receivedMessages = [ReceivedMessage]()
    
    private var result: Result<[LocalUserItem], Error>
    
    init(result: Result<[LocalUserItem], Error>) {
        self.result = result
    }
    
    func retrieveAll() throws -> [LocalUserItem] {
        receivedMessages.append(.retrieve)
        return try result.get()
    }
}
