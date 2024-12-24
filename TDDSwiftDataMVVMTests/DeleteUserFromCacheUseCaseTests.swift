//
//  DeleteUserFromCacheUseCaseTests.swift
//  TDDSwiftDataMVVMTests
//
//  Created by Mushthak Ebrahim on 24/12/24.
//

import Testing
import TDDSwiftDataMVVM

extension LocaleUserLoader {
    func deleteUser() async throws {
        do {
            try await store.remove()
        } catch  {
            throw Error.deletion
        }
    }
}

struct DeleteUserFromCacheUseCaseTests {
    
    @Test func test_init_doesNotMessageStoreUponCreation() async {
        let (_, store) = makeSUT()
        #expect(store.receivedMessages.isEmpty)
    }
    
    @Test func test_deleteUser_requestsDeleteFromStore() async throws {
        let (sut, store) = makeSUT()
        try await sut.deleteUser()
        
        #expect(store.receivedMessages.contains(.delete))
    }
    
    @Test func test_deleteUser_failsOnDeletionError() async {
        let (sut, _) = makeSUT(with: .failure(.deletionError))
        do {
            try await sut.deleteUser()
            #expect(Bool(false), "Expect to throw \(LocaleUserLoader.Error.deletion) error but got success instead")
        } catch  {
            #expect(error as? LocaleUserLoader.Error == LocaleUserLoader.Error.deletion)
        }
    }
    
    
    //MARK: Helpers
    private func makeSUT(with result: Result<[LocalUserItem], UserStoreSpy.Error> = .success([])) -> (LocaleUserLoader, UserStoreSpy) {
        let store = UserStoreSpy(result: result)
        let sut = LocaleUserLoader(store: store)
        
        return (sut, store)
    }
    
}
