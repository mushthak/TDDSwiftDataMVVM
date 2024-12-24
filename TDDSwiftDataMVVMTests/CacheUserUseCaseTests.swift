//
//  CacheUserUseCaseTests.swift
//  TDDSwiftDataMVVMTests
//
//  Created by Mushthak Ebrahim on 24/12/24.
//

import Testing
import TDDSwiftDataMVVM

extension LocaleUserLoader {
    func saveUser() async {
        await store.insert()
    }
}

struct CacheUserUseCaseTests {

    @Test func test_init_doesNotMessageStoreUponCreation() async throws {
        let (_, store) = makeSUT()
        #expect(store.receivedMessages.isEmpty)
    }
    
    @Test func test_saveUser_requestsNewCacheInsertion() async {
        let (sut, store) = makeSUT()
        await sut.saveUser()
        
        #expect(store.receivedMessages == [.insert])
    }
    
    //MARK: Helpers
    private func makeSUT(with result: Result<[LocalUserItem], UserStoreSpy.Error> = .success([])) -> (LocaleUserLoader, UserStoreSpy) {
        let store = UserStoreSpy(result: result)
        let sut = LocaleUserLoader(store: store)
        
        return (sut, store)
    }

}
