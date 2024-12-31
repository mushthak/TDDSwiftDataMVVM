//
//  TDDSwiftDataMVVMViewTests.swift
//  TDDSwiftDataMVVMViewTests
//
//  Created by Mushthak Ebrahim on 29/12/24.
//

import Testing
import TDDSwiftDataMVVMView
import TDDSwiftDataMVVM

struct UserViewModelAdapterTests {
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
