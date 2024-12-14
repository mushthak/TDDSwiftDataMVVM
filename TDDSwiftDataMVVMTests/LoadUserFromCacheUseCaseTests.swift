//
//  LoadUserFromCacheUseCaseTests.swift
//  TDDSwiftDataMVVMTests
//
//  Created by Mushthak Ebrahim on 08/12/24.
//

import Testing
import Foundation

protocol UserStore {
    func retrieveAll() async throws -> [LocalUserItem]
}

class UserStoreSpy: UserStore {
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
    
    func retrieveAll() throws -> [LocalUserItem] {
        receivedMessages.append(.retrieve)
        return try result.get()
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
    
    func loadUsers() async throws -> [User] {
        do {
            return try await store.retrieveAll().toModels()
        } catch  {
            throw Error.retrieval
        }
    }
}

private extension Array where Element == LocalUserItem {
    func toModels() -> [User] {
        return map{User(id: $0.id)}
    }
}

struct LocalUserItem {
    let id: UUID
}

struct User: Equatable {
    let id: UUID
}


struct LoadUserFromCacheUseCaseTests {
    
    @Test func test_init_doesNotMessageStoreUponCreation() async throws {
        let (_, store) = makeSUT()
        #expect(store.receivedMessages.isEmpty)
    }
    
    
    @Test func test_loadUser_requestCacheRetrieval() async throws {
        let (sut, store) = makeSUT()
        
        _ = try await sut.loadUsers()
        
        #expect(store.receivedMessages == [.retrieve])
    }
    
    @Test func test_loadUserTwice_requestCacheRetrievalTwice() async throws {
        let (sut, store) = makeSUT()
        
        _ = try await sut.loadUsers()
        _ = try await sut.loadUsers()
        
        #expect(store.receivedMessages == [.retrieve, .retrieve])
    }
    
    @Test func test_loadUser_failsOnRetrievalError() async throws {
        let (sut, _) = makeSUT(with: .failure(.retrievalError))
        
        do {
            _ = try await sut.loadUsers()
            #expect(Bool(false), "Expect to throw \(LocaleUserLoader.Error.retrieval) error but got success instead")
        } catch  {
            #expect(error as? LocaleUserLoader.Error == LocaleUserLoader.Error.retrieval)
        }
        
    }
    
    @Test func test_loadUser_deliversEmptyUsersWhenCacheIsEmpty() async throws {
        let (sut, _) = makeSUT(with: .success([]))
        
        let result = try await sut.loadUsers()
        
        #expect(result == [])
    }
    
    //MARK: Helpers
    private func makeSUT(with result: Result<[LocalUserItem], UserStoreSpy.Error> = .success([])) -> (LocaleUserLoader, UserStoreSpy) {
        let store = UserStoreSpy(result: result)
        let sut = LocaleUserLoader(store: store)
        
        return (sut, store)
    }
    
}
