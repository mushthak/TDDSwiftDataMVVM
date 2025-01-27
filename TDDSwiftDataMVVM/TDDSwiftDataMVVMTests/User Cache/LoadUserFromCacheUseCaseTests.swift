//
//  LoadUserFromCacheUseCaseTests.swift
//  TDDSwiftDataMVVMTests
//
//  Created by Mushthak Ebrahim on 08/12/24.
//

import Testing
import Foundation
import TDDSwiftDataMVVM

@MainActor
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
    
    @Test func test_loadUser_deliversCachedUsersOnNonEmptyCache() async throws {
        let (stubUsers, expectedUsers) = makeTestUsers()
        let (sut, _) = makeSUT(with: .success(stubUsers))
        
        do {
            let result = try await sut.loadUsers()
            #expect(result == expectedUsers)
        } catch {
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
