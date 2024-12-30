//
//  TDDSwiftDataMVVMViewTests.swift
//  TDDSwiftDataMVVMViewTests
//
//  Created by Mushthak Ebrahim on 29/12/24.
//

import Testing
import TDDSwiftDataMVVMView
@testable import TDDSwiftDataMVVM

private struct UserViewModel {
    let name: String
}

private class UserViewModelAdapter {
    let loader: UserCache
    
    init(loader: UserCache) {
        self.loader = loader
    }
    
    func loadUserViewModels() async throws -> [UserViewModel] {
        let result = try await loader.loadUsers()
        return result.toViewModels()
    }
}

private extension Array where Element == User {
    func toViewModels() -> [UserViewModel] {
        return map{UserViewModel(name: $0.name)}
    }
}

private class UserCacheSpy: UserCache {
    
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

struct TDDSwiftDataMVVMViewTests {
    @Test func test_map_mapsUsersToUserViewModels() async {
        let usersStub: [User] = [
            makeUniqueUser().model,
            makeUniqueUser().model,
        ]
        let sut = UserViewModelAdapter(loader: UserCacheSpy(result: .success(usersStub)))
        do {
            let userViewModels: [UserViewModel] = try await sut.loadUserViewModels()
            #expect(userViewModels[0].name == usersStub[0].name)
            #expect(userViewModels[1].name == usersStub[1].name)
        } catch  {
            Issue.record("Expected success but got \(error) instead")
        }
    }
}
