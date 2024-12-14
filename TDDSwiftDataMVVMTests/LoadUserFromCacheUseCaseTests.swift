//
//  LoadUserFromCacheUseCaseTests.swift
//  TDDSwiftDataMVVMTests
//
//  Created by Mushthak Ebrahim on 08/12/24.
//

import Testing

protocol UserStore {
    func retrieveAll()
}

class MockUserStore: UserStore {
    enum ReceivedMessage {
        case retrieve
    }
    
    private(set) var receivedMessages = [ReceivedMessage]()
    
    func retrieveAll() {
        receivedMessages.append(.retrieve)
    }
}

class LocaleUserLoader {
    let store: UserStore
    
    init(store: UserStore) {
        self.store = store
    }
    
    func loadUsers() {
        store.retrieveAll()
    }
}


struct LoadUserFromCacheUseCaseTests {
    
    @Test func test_init_doesNotMessageStoreUponCreation() async throws {
        let (_, store) = makeSUT()
        #expect(store.receivedMessages.isEmpty)
    }
    
    @Test func test_loadUser_requestCacheRetrieval() async throws {
        let (sut, store) = makeSUT()
        
        sut.loadUsers()
        
        #expect(store.receivedMessages == [.retrieve])
    }
    
    @Test func test_loadUserTwice_requestCacheRetrievalTwice() async throws {
        let (sut, store) = makeSUT()
        
        sut.loadUsers()
        sut.loadUsers()
        
        #expect(store.receivedMessages == [.retrieve, .retrieve])
    }
    
    //MARK: Helpers
    private func makeSUT() -> (LocaleUserLoader, MockUserStore) {
        let store = MockUserStore()
        let sut = LocaleUserLoader(store: store)
        
        return (sut, store)
    }
    
}
