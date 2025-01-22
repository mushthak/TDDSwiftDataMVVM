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
    
    init(result: Result<[User], Error>, insertionError: Error? = nil) {
        self.result = result
        self.insertionError = insertionError
    }
    
    func loadUsers() async throws -> [User] {
        return try result.get()
    }
    
    func saveUser(user: User) async throws {
        guard insertionError == nil  else {
            throw insertionError!
        }
        var userList = try result.get()
        userList.append(user)
        result = .success(userList)
    }
    
    func deleteUser(user: User) async throws {}

}
