//
//  DeleteUserFromCacheUseCaseTests.swift
//  TDDSwiftDataMVVMTests
//
//  Created by Mushthak Ebrahim on 24/12/24.
//

import Testing
import TDDSwiftDataMVVM

extension LocaleUserLoader {
    func deleteUser() async {
        await store.remove()
    }
}

struct DeleteUserFromCacheUseCaseTests {
    
    @Test func test_init_doesNotMessageStoreUponCreation() async {
        let (_, store) = makeSUT()
        #expect(store.receivedMessages.isEmpty)
    }
    
    @Test func test_deleteUser_requestsDeleteFromStore() async {
        let (sut, store) = makeSUT()
        await sut.deleteUser()
        
        #expect(store.receivedMessages.contains(.delete))
    }
    
    
    //MARK: Helpers
    private func makeSUT(with result: Result<[LocalUserItem], UserStoreSpy.Error> = .success([])) -> (LocaleUserLoader, UserStoreSpy) {
        let store = UserStoreSpy(result: result)
        let sut = LocaleUserLoader(store: store)
        
        return (sut, store)
    }
    
}
