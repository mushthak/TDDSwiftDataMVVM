//
//  CacheUserUseCaseTests.swift
//  TDDSwiftDataMVVMTests
//
//  Created by Mushthak Ebrahim on 24/12/24.
//

import Foundation
import Testing
import TDDSwiftDataMVVM

extension LocaleUserLoader {
    func saveUser(user: User) async throws {
        do {
            try await store.insert(user: user.toLocal)
        } catch  {
            throw Error.insertion
        }
    }
}

private extension User {
    var toLocal: LocalUserItem {
        LocalUserItem(id: self.id)
    }
}

struct CacheUserUseCaseTests {

    @Test func test_init_doesNotMessageStoreUponCreation() async throws {
        let (_, store) = makeSUT()
        #expect(store.receivedMessages.isEmpty)
    }
    
    @Test func test_saveUser_requestsNewCacheInsertion() async throws {
        let (sut, store) = makeSUT()
        let user = makeUniqueUser()
        try await sut.saveUser(user: user)
        
        #expect(store.receivedMessages == [.insert(user: user.toLocal)])
    }
    
    @Test func test_saveUser_failsOnInsertionError() async {
        let (sut, _) = makeSUT(with: .failure(.insertionError))
        
        do {
            try await sut.saveUser(user: makeUniqueUser())
            #expect(Bool(false), "Expect to throw \(LocaleUserLoader.Error.insertion) error but got success instead")
        } catch  {
            #expect(error as? LocaleUserLoader.Error == LocaleUserLoader.Error.insertion)
        }
    }
    
    @Test func test_save_succeedsOnSuccessfullCacheInsertion () async {
        let (sut, _) = makeSUT()
        
        do {
            try await sut.saveUser(user: makeUniqueUser())
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
