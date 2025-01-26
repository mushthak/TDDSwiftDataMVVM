//
//  UserCacheSpy.swift
//  TDDSwiftDataMVVM
//
//  Created by Mushthak Ebrahim on 07/01/25.
//
import TDDSwiftDataMVVM


class UserCacheSpy: UserCache {
    
    private var result: Result<[User], Error>
   
    private var insertionError: Error?
    private var deletionError: Error?
    
    enum ReceivedMessage: Equatable {
        case delete(user: User)
        case insert(name: String)
    }
    
    private(set) var receivedMessages = [ReceivedMessage]()
    
    init(result: Result<[User], Error>, insertionError: Error? = nil, deletionError: Error? = nil) {
        self.result = result
        self.insertionError = insertionError
        self.deletionError = deletionError
    }
    
    func loadUsers() async throws -> [User] {
        return try result.get()
    }
    
    func saveUser(user: User) async throws {
        receivedMessages.append(.insert(name: user.name))
        guard insertionError == nil  else {
            throw insertionError!
        }
        var userList = try result.get()
        userList.append(user)
        result = .success(userList)
    }
    
    func deleteUser(user: User) async throws {
        receivedMessages.append(.delete(user: user))
        guard deletionError == nil  else {
            throw deletionError!
        }
        let userList = try result.get()
        let newList = userList.filter { $0.id != user.id }
        result = .success(newList)
    }

}
