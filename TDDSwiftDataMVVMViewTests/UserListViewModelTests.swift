//
//  UserListViewModelTests.swift
//  TDDSwiftDataMVVMViewTests
//
//  Created by Mushthak Ebrahim on 21/01/25.
//

import Testing
import TDDSwiftDataMVVMView

class UserListViewModel {
    var users: [UserViewModel] = []
    init() {}
}

struct UserListViewModelTests {

    @Test func test_init_doesNotLoadUsers() async throws {
        let sut = UserListViewModel()
        #expect(sut.users.isEmpty)
    }

}
