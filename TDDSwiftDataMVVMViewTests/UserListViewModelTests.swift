//
//  UserListViewModelTests.swift
//  TDDSwiftDataMVVMViewTests
//
//  Created by Mushthak Ebrahim on 21/01/25.
//

import Testing
import TDDSwiftDataMVVM
import TDDSwiftDataMVVMView
import Foundation

class UserListViewModel {
    //MARK: Dependencies
    let userViewModelAdapter: UserViewModelAdapter
    let userRepository: UserCache
    
    //MARK: State
    var users: [UserViewModel] = []
    var isEmptyUserMessageVisible: Bool = false
    
    init(userViewModelAdapter: UserViewModelAdapter, userRepository: UserCache) {
        self.userViewModelAdapter = userViewModelAdapter
        self.userRepository = userRepository
    }
    
    func loadUsers() async {
        users = try! await userViewModelAdapter.loadUserViewModels()
        isEmptyUserMessageVisible = users.isEmpty
    }
    
    func addUser(_ name: String) async {
        let newUser = UserViewModel(name: name)
        do {
            try await userRepository.saveUser(user: newUser.toDomainModel)
            self.users.append(newUser)
        } catch  {}
    }
}

private extension UserViewModel {
    var toDomainModel: User {
        User.init(id: UUID(), name: self.name)
    }
}

struct UserListViewModelTests {

    @Test func test_init_doesNotLoadUsers() async throws {
        let usersStub: [User] = [
            makeUniqueUser().model,
            makeUniqueUser().model,
        ]
        let userCache = UserCacheSpy(result: .success(usersStub))
        let adapter = UserViewModelAdapter(loader: userCache)
        let sut = UserListViewModel(userViewModelAdapter: adapter, userRepository: userCache)
        #expect(sut.users.isEmpty)
    }
    
    @Test func test_loadUsers_loadUsersFromAdapter() async throws {
        let usersStub: [User] = [
            makeUniqueUser().model,
            makeUniqueUser().model,
        ]
        let userCache = UserCacheSpy(result: .success(usersStub))
        let adapter = UserViewModelAdapter(loader: userCache)
        let sut = UserListViewModel(userViewModelAdapter: adapter, userRepository: userCache)
        await sut.loadUsers()
        #expect(!sut.users.isEmpty)
    }
    
    @Test func test_loadUsers_showPlaceHolderTextOnEmptyUsers() async throws {
        let usersStub: [User] = []
        let userCache = UserCacheSpy(result: .success(usersStub))
        let adapter = UserViewModelAdapter(loader: userCache)
        let sut = UserListViewModel(userViewModelAdapter: adapter, userRepository: userCache)
        await sut.loadUsers()
        #expect(sut.users.isEmpty)
        #expect(sut.isEmptyUserMessageVisible)
    }
    
    @Test func test_loadUsers_hidePlaceHolderTextOnNonEmptyUsers() async throws {
        let usersStub: [User] = [
            makeUniqueUser().model,
            makeUniqueUser().model,
        ]
        let userCache = UserCacheSpy(result: .success(usersStub))
        let adapter = UserViewModelAdapter(loader: userCache)
        let sut = UserListViewModel(userViewModelAdapter: adapter, userRepository: userCache)
        await sut.loadUsers()
        #expect(!sut.users.isEmpty)
        #expect(!sut.isEmptyUserMessageVisible)
    }
    
    @Test func test_addUser_updateUserListOnSuccessfullInsertion() async throws {
        let usersStub: [User] = []
        let userCache = UserCacheSpy(result: .success(usersStub))
        let adapter = UserViewModelAdapter(loader: userCache)
        
        let sut = UserListViewModel(userViewModelAdapter: adapter, userRepository: userCache)
        await sut.loadUsers()
        #expect(sut.users.isEmpty)
        
        let newUser = "New User"
        await sut.addUser(newUser)
        
        #expect(sut.users.count == 1)
    }
    
    @Test func test_addUser_doesnotUpdateUserListOnInsertionFailure() async throws {
        let usersStub: [User] = []
        let userCache = UserCacheSpy(result: .success(usersStub), insertionError: NSError())
        let adapter = UserViewModelAdapter(loader: userCache)
        
        let sut = UserListViewModel(userViewModelAdapter: adapter, userRepository: userCache)
        
        let newUser = "New User"
        await sut.addUser(newUser)
        
        await sut.loadUsers()
        #expect(sut.users.count == 0)
    }
}
