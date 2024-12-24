//
//  CacheUserUseCaseTests.swift
//  TDDSwiftDataMVVMTests
//
//  Created by Mushthak Ebrahim on 24/12/24.
//

import Testing
import TDDSwiftDataMVVM

extension LocaleUserLoader {
    func saveUser() async throws {
        do {
            try await store.insert()
        } catch  {
            throw Error.insertion
        }
    }
}

struct CacheUserUseCaseTests {

    @Test func test_init_doesNotMessageStoreUponCreation() async throws {
        let (_, store) = makeSUT()
        #expect(store.receivedMessages.isEmpty)
    }
    
    @Test func test_saveUser_requestsNewCacheInsertion() async throws {
        let (sut, store) = makeSUT()
        try await sut.saveUser()
        
        #expect(store.receivedMessages == [.insert])
    }
    
    @Test func test_saveUser_failsOnInsertionError() async {
        let (sut, _) = makeSUT(with: .failure(.insertionError))
        
        do {
            try await sut.saveUser()
            #expect(Bool(false), "Expect to throw \(LocaleUserLoader.Error.insertion) error but got success instead")
        } catch  {
            #expect(error as? LocaleUserLoader.Error == LocaleUserLoader.Error.insertion)
        }
    }
    
    //MARK: Helpers
    private func makeSUT(with result: Result<[LocalUserItem], UserStoreSpy.Error> = .success([])) -> (LocaleUserLoader, UserStoreSpy) {
        let store = UserStoreSpy(result: result)
        let sut = LocaleUserLoader(store: store)
        
        return (sut, store)
    }

}
