//
//  UserViewModelAdapter.swift
//  TDDSwiftDataMVVM
//
//  Created by Mushthak Ebrahim on 30/12/24.
//

import TDDSwiftDataMVVM

public class UserViewModelAdapter {
    let loader: UserCache
    
    public init(loader: UserCache) {
        self.loader = loader
    }
    
    public func loadUserViewModels() async throws -> [UserViewModel] {
        let result = try await loader.loadUsers()
        return result.toViewModels()
    }
}

private extension Array where Element == User {
    func toViewModels() -> [UserViewModel] {
        return map{UserViewModel(id: $0.id, name: $0.name)}
    }
}
