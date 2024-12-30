//
//  UserCacheSpy.swift
//  TDDSwiftDataMVVM
//
//  Created by Mushthak Ebrahim on 30/12/24.
//

@testable import TDDSwiftDataMVVM


class UserCacheSpy: UserCache {
    
    private var result: Result<[User], Error>
    
    init(result: Result<[User], Error>) {
        self.result = result
    }
    
    func loadUsers() async throws -> [User] {
        return try result.get()
    }
    
    func saveUser(user: User) async throws {}
    
    func deleteUser(user: User) async throws {}

}
