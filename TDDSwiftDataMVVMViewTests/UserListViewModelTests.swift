//
//  UserListViewModelTests.swift
//  TDDSwiftDataMVVMViewTests
//
//  Created by Mushthak Ebrahim on 21/01/25.
//

import Testing
import TDDSwiftDataMVVM
import TDDSwiftDataMVVMView

class UserListViewModel {
    //MARK: Dependencies
    let userViewModelAdapter: UserViewModelAdapter
    
    //MARK: State
    var users: [UserViewModel] = []
    var isEmptyUserMessageVisible: Bool = false
    
    init(userViewModelAdapter: UserViewModelAdapter) {
        self.userViewModelAdapter = userViewModelAdapter
    }
    
    func loadUsers() async {
        users = try! await userViewModelAdapter.loadUserViewModels()
        isEmptyUserMessageVisible = users.isEmpty
    }
}

struct UserListViewModelTests {

    @Test func test_init_doesNotLoadUsers() async throws {
        let usersStub: [User] = [
            makeUniqueUser().model,
            makeUniqueUser().model,
        ]
        let adapter = UserViewModelAdapter(loader: UserCacheSpy(result: .success(usersStub)))
        let sut = UserListViewModel(userViewModelAdapter: adapter)
        #expect(sut.users.isEmpty)
    }
    
    @Test func test_loadUsers_loadUsersFromAdapter() async throws {
        let usersStub: [User] = [
            makeUniqueUser().model,
            makeUniqueUser().model,
        ]
        let adapter = UserViewModelAdapter(loader: UserCacheSpy(result: .success(usersStub)))
        let sut = UserListViewModel(userViewModelAdapter: adapter)
        await sut.loadUsers()
        #expect(!sut.users.isEmpty)
    }
    
    @Test func test_loadUsers_showPlaceHolderTextOnEmptyUsers() async throws {
        let usersStub: [User] = []
        let adapter = UserViewModelAdapter(loader: UserCacheSpy(result: .success(usersStub)))
        let sut = UserListViewModel(userViewModelAdapter: adapter)
        await sut.loadUsers()
        #expect(sut.users.isEmpty)
        #expect(sut.isEmptyUserMessageVisible)
    }
    
    @Test func test_loadUsers_hidePlaceHolderTextOnNonEmptyUsers() async throws {
        let usersStub: [User] = [
            makeUniqueUser().model,
            makeUniqueUser().model,
        ]
        let adapter = UserViewModelAdapter(loader: UserCacheSpy(result: .success(usersStub)))
        let sut = UserListViewModel(userViewModelAdapter: adapter)
        await sut.loadUsers()
        #expect(!sut.users.isEmpty)
        #expect(!sut.isEmptyUserMessageVisible)
    }

}
