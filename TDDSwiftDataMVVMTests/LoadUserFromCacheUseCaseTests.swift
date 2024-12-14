//
//  LoadUserFromCacheUseCaseTests.swift
//  TDDSwiftDataMVVMTests
//
//  Created by Mushthak Ebrahim on 08/12/24.
//

import Testing

protocol UserStore {
    func retrieveAll() throws
}

class MockUserStore: UserStore {
    enum ReceivedMessage {
        case retrieve
    }
    
    enum Error: Swift.Error {
        case retrievalError
    }
    
    private(set) var receivedMessages = [ReceivedMessage]()
    
    private var result: Result<[LocalUserItem], Error>
    
    init(result: Result<[LocalUserItem], Error>) {
        self.result = result
    }
    
    func retrieveAll() throws {
        receivedMessages.append(.retrieve)
        
        switch result {
        case .success:
            return
        case .failure:
            throw Error.retrievalError
        }
    }
}

class LocaleUserLoader {
    let store: UserStore
    
    enum Error: Swift.Error {
        case retrieval
    }
    
    init(store: UserStore) {
        self.store = store
    }
    
    func loadUsers() throws {
        do {
            try store.retrieveAll()
        } catch  {
            throw Error.retrieval
        }
    }
}

struct LocalUserItem {}


struct LoadUserFromCacheUseCaseTests {
    
    @Test func test_init_doesNotMessageStoreUponCreation() async throws {
        let (_, store) = makeSUT()
        #expect(store.receivedMessages.isEmpty)
    }
    
    @Test func test_loadUser_requestCacheRetrieval() async throws {
        let (sut, store) = makeSUT()
        
        try sut.loadUsers()
        
        #expect(store.receivedMessages == [.retrieve])
    }
    
    @Test func test_loadUserTwice_requestCacheRetrievalTwice() async throws {
        let (sut, store) = makeSUT()
        
        try sut.loadUsers()
        try sut.loadUsers()
        
        #expect(store.receivedMessages == [.retrieve, .retrieve])
    }
    
    @Test func test_loadUser_failsOnRetrievalError() async throws {
        let (sut, _) = makeSUT(with: .failure(.retrievalError))
        
        do {
            try sut.loadUsers()
            #expect(Bool(false), "Expect to throw \(LocaleUserLoader.Error.retrieval) error but got success instead")
        } catch  {
            #expect(error as? LocaleUserLoader.Error == LocaleUserLoader.Error.retrieval)
        }
        
    }
    
    //MARK: Helpers
    private func makeSUT(with result: Result<[LocalUserItem], MockUserStore.Error> = .success([])) -> (LocaleUserLoader, MockUserStore) {
        let store = MockUserStore(result: result)
        let sut = LocaleUserLoader(store: store)
        
        return (sut, store)
    }
    
}
