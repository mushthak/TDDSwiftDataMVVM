//
//  TDDSwiftDataMVVMViewTests.swift
//  TDDSwiftDataMVVMViewTests
//
//  Created by Mushthak Ebrahim on 29/12/24.
//

import Testing
import TDDSwiftDataMVVMView
import TDDSwiftDataMVVM
import Foundation

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
    
    @Test func test_saveUser_requestsCacheInsertion() async {
        let (sut, store) = makeSUT()
        do {
            let newUser = "New User"
            let _ = try await sut.saveUser(name: newUser)
            #expect(true, "Expected cache insertion to happen")
            #expect(store.receivedMessages == [.insert(name: newUser)])
        } catch  {
            Issue.record("Expected success but got \(error) instead")
        }
    }
    
    @Test func test_saveUser_throwsOnInsertionError() async {
        let (sut, _) = makeSUT(insertionError: NSError())
        do {
            let newUser = "New User"
            let _ = try await sut.saveUser(name: newUser)
            Issue.record("Expected to throw error but got success instead")
        } catch  {
            #expect(true, "Expect to throw error")
        }
    }
    
    @Test func test_deleteUser_requestsCacheDeletion() async {
        let userStub: User = makeUniqueUser().model
        let (sut, store) = makeSUT(result: .success([userStub]))
        do {
            try await sut.deleteUser(user: UserViewModel(id: userStub.id, name: userStub.name))
            #expect(true, "Expected cache deletion to happen")
            #expect(store.receivedMessages == [.delete(user: userStub)])
        } catch  {
            Issue.record("Expected success but got \(error) instead")
        }
    }
    
    @Test func test_deleteUser_throwsOnDeletionError() async {
        let userStub: User = makeUniqueUser().model
        let (sut, _) = makeSUT(result: .success([userStub]), deletionError: NSError())
        do {
            try await sut.deleteUser(user: UserViewModel(id: userStub.id, name: userStub.name))
            Issue.record("Expected to throw error but got success instead")
        } catch  {
            #expect(true, "Expect to throw error")
        }
    }
    
    private func makeSUT(result: Result<[User], Error> = .success([]), insertionError: Error? = nil, deletionError: Error? = nil) -> (UserViewModelAdapter, UserCacheSpy) {
        let cache = UserCacheSpy(result: result, insertionError: insertionError, deletionError: deletionError)
        let sut = UserViewModelAdapter(loader: cache)
        return (sut, cache)
    }
}
