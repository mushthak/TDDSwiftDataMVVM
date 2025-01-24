//
//  UserViewModelAdapter.swift
//  TDDSwiftDataMVVM
//
//  Created by Mushthak Ebrahim on 30/12/24.
//

import TDDSwiftDataMVVM
import Foundation

public class UserViewModelAdapter {
    let loader: UserCache
    
    public init(loader: UserCache) {
        self.loader = loader
    }
    
    public func loadUserViewModels() async throws -> [UserViewModel] {
        let result = try await loader.loadUsers()
        return result.toViewModels()
    }
    
    public func saveUser(name: String) async throws -> UserViewModel {
        let newUser = UserViewModel(id: UUID(), name: name)
        try await loader.saveUser(user: newUser.toDomainModel)
        return newUser
    }
    
    public func deleteUser(user: UserViewModel) async throws {
        try await loader.deleteUser(user: user.toDomainModel)
    }
}

private extension Array where Element == User {
    func toViewModels() -> [UserViewModel] {
        return map{UserViewModel(id: $0.id, name: $0.name)}
    }
}

private extension UserViewModel {
    var toDomainModel: User {
        User.init(id: self.id, name: self.name)
    }
}
