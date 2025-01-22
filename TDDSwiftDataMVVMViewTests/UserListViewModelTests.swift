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

struct UserListViewModelTests {

    @Test func test_init_doesNotLoadUsers() async throws {
        let usersStub: [User] = [
            makeUniqueUser().model,
            makeUniqueUser().model,
        ]
        let (sut, _) = makeSUT(result: .success(usersStub))
        #expect(sut.users.isEmpty)
    }
    
    @Test func test_loadUsers_loadUsersFromAdapter() async throws {
        let usersStub: [User] = [
            makeUniqueUser().model,
            makeUniqueUser().model,
        ]
        let (sut, _) = makeSUT(result: .success(usersStub))
        await sut.loadUsers()
        #expect(!sut.users.isEmpty)
    }
    
    @Test func test_loadUsers_showPlaceHolderTextOnEmptyUsers() async throws {
        let (sut, _) = makeSUT()
        await sut.loadUsers()
        #expect(sut.users.isEmpty)
        #expect(sut.isEmptyUserMessageVisible)
    }
    
    @Test func test_loadUsers_hidePlaceHolderTextOnNonEmptyUsers() async throws {
        let usersStub: [User] = [
            makeUniqueUser().model,
            makeUniqueUser().model,
        ]
        let (sut, _) = makeSUT(result: .success(usersStub))
        await sut.loadUsers()
        #expect(!sut.users.isEmpty)
        #expect(!sut.isEmptyUserMessageVisible)
    }
    
    @Test func test_addUser_updateUserListOnSuccessfullInsertion() async throws {
        let (sut, _) = makeSUT()
        await sut.loadUsers()
        #expect(sut.users.isEmpty)
        
        let newUser = "New User"
        await sut.addUser(newUser)
        
        #expect(sut.users.count == 1)
    }
    
    @Test func test_addUser_doesnotUpdateUserListOnInsertionFailure() async throws {
        let (sut, _) = makeSUT(insertionError: NSError())
        
        let newUser = "New User"
        await sut.addUser(newUser)
        
        await sut.loadUsers()
        #expect(sut.users.count == 0)
    }
    
    @Test func test_addUser_hideEmptyUserMessageOnSuccessfullInsertion() async throws {
        let (sut, _) = makeSUT()
        await sut.loadUsers()
        #expect(sut.users.isEmpty)
        #expect(sut.isEmptyUserMessageVisible)
        
        let newUser = "New User"
        await sut.addUser(newUser)
        
        #expect(sut.users.count == 1)
        #expect(!sut.isEmptyUserMessageVisible)
    }
    
    @Test func test_addUser_showInsertionErrorAlertOnInsertionFailure() async throws {
        let (sut, _) = makeSUT(insertionError: NSError())
        
        let newUser = "New User"
        await sut.addUser(newUser)
        
        #expect(sut.isErrorAlertPresented == true)
        #expect(sut.errorMessage == "Something went wrong while adding user")
    }
    
    @Test func test_deleteUser_removesUserFromListOnSuccessfullDeletion() async throws {
        let usersStub: [User] = [
            makeUniqueUser().model
        ]
        let (sut, _) = makeSUT(result: .success(usersStub))
        await sut.loadUsers()
        #expect(sut.users.count == 1)
        
        await sut.deleteUser(at: 0)
        
        #expect(sut.users.count == 0)
    }
    
    @Test func test_deleteUser_doesnotRemoveUserFromListOnDeletionFailure() async throws {
        
        let userStub:User = makeUniqueUser().model
        let (sut, store) = makeSUT(result: .success([userStub]), deletionError: NSError())
        await sut.loadUsers()
        #expect(sut.users.count == 1)
        
        await sut.deleteUser(at: 0)
        
        #expect(store.receivedMessages == [.delete(user: userStub)])
        #expect(sut.users.count == 1)
    }
    
    @Test func test_deleteUser_doesNotRequestUserDeletionIfIndexIsOutOfBounds() async throws {
        let usersStub: [User] = [
            makeUniqueUser().model
        ]
        let (sut, store) = makeSUT(result: .success(usersStub), deletionError: NSError())
        await sut.loadUsers()
        #expect(sut.users.count == 1)
        
        await sut.deleteUser(at: -1)
        
        #expect(store.receivedMessages == [])
        #expect(sut.users.count == 1)
    }
    
    @Test func test_deleteUser_showEmptyUserMessageForEmptyUsersOnDeletion() async throws {
        
        let userStub:User = makeUniqueUser().model
        let (sut, store) = makeSUT(result: .success([userStub]))
        await sut.loadUsers()
        #expect(sut.users.count == 1)
        
        await sut.deleteUser(at: 0)
        
        #expect(store.receivedMessages == [.delete(user: userStub)])
        #expect(sut.users.count == 0)
        #expect(sut.isEmptyUserMessageVisible, "Expect empty user message to be visible but it is not")
    }
    
    @Test func test_deleteUser_showDeleteErrorAlertOnDeletionFailure() async throws {
        let userStub:User = makeUniqueUser().model
        let (sut, _) = makeSUT(result: .success([userStub]), deletionError: NSError())
        await sut.loadUsers()
        
        await sut.deleteUser(at: 0)
        
        #expect(sut.isErrorAlertPresented == true)
        #expect(sut.errorMessage == "Something went wrong with deleting user")
    }
    
    //MARK: Helpers
    private func makeSUT(result: Result<[User], Error> = .success([]), insertionError: Error? = nil, deletionError: Error? = nil) -> (UserListViewModel, UserCacheSpy) {
        let userCache = UserCacheSpy(result: result, insertionError: insertionError, deletionError: deletionError)
        let adapter = UserViewModelAdapter(loader: userCache)
        let sut = UserListViewModel(userViewModelAdapter: adapter)
        return (sut, userCache)
    }
}
