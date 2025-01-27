//
//  DeleteUserFromCacheUseCaseTests.swift
//  TDDSwiftDataMVVMTests
//
//  Created by Mushthak Ebrahim on 24/12/24.
//

import Testing
import TDDSwiftDataMVVM

@MainActor
struct DeleteUserFromCacheUseCaseTests {
    
    @Test func test_init_doesNotMessageStoreUponCreation() async {
        let (_, store) = makeSUT()
        #expect(store.receivedMessages.isEmpty)
    }
    
    @Test func test_deleteUser_requestsDeleteFromStore() async throws {
        let (sut, store) = makeSUT()
        let user = makeUniqueUser()
        try await sut.deleteUser(user: user.model)
        
        #expect(store.receivedMessages.contains(.delete(user: user.local)))
    }
    
    @Test func test_deleteUser_failsOnDeletionError() async {
        let (sut, _) = makeSUT(with: .failure(.deletionError))
        do {
            let user = makeUniqueUser()
            try await sut.deleteUser(user: user.model)
            #expect(Bool(false), "Expect to throw \(LocaleUserLoader.Error.deletion) error but got success instead")
        } catch  {
            #expect(error as? LocaleUserLoader.Error == LocaleUserLoader.Error.deletion)
        }
    }
    
    
    @Test func test_deleteUser_successfullyDeletesUserFromStore() async  {
        let (sut, _) = makeSUT(with: .success([]))
        do {
            let user = makeUniqueUser()
            try await sut.deleteUser(user: user.model)
        } catch  {
            #expect(Bool(false), "Expect to succeed but got \(error) error instead")
        }
    }
    
    //MARK: Helpers
    private func makeSUT(with result: Result<[LocalUserItem], UserStoreSpy.Error> = .success([])) -> (LocaleUserLoader, UserStoreSpy) {
        let store = UserStoreSpy(result: result)
        let sut = LocaleUserLoader(store: store)
        
        return (sut, store)
    }
    
}
