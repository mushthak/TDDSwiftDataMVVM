//
//  SwiftDataUserStoreTests.swift
//  TDDSwiftDataMVVMTests
//
//  Created by Mushthak Ebrahim on 24/12/24.
//

import Foundation
import Testing
import SwiftData
import TDDSwiftDataMVVM

struct SwiftDataUserStoreTests {

    @Test func test_retrieveAll_deliversEmptyOnEmptyCache() async throws {
        let sut = await makeSUT()
        do {
            let result = try await sut.retrieveAll()
            
            #expect(result.isEmpty, "Expect the result to be empty but got \(result) instead")
        } catch {
            #expect(Bool(false), "Expect to succeed but got \(error) error instead")
        }
    }
    
    @Test func test_retrieve_hasNoSideEffectsOnEmptyCache() async {
        let sut = await makeSUT()
        do {
            var result = try await sut.retrieveAll()
            #expect(result.isEmpty, "Expect the result to be empty but got \(result) instead")
            result = try await sut.retrieveAll()
            #expect(result.isEmpty, "Expect the result to be empty but got \(result) instead")
        } catch {
            #expect(Bool(false), "Expect to succeed but got \(error) error instead")
        }
    }
    
    @Test func test_retrive_deliversFoundValuesOnNonEmptyCache() async {
        let sut = await makeSUT()
        do {
            let user = makeUniqueUser()
            try await sut.insert(user: user.local)
            let result = try await sut.retrieveAll()
            
            #expect(result == [user.local], "Expect the result to be \(user.model) but got \(result) instead")
        } catch {
            #expect(Bool(false), "Expect to succeed but got \(error) error instead")
        }
    }
    
    @Test func test_insert_deliversNoErrorOnEmptyCache() async {
        let sut = await makeSUT()
        do {
            let result = try await sut.retrieveAll()
            #expect(result.isEmpty, "Expect the result to be empty but got \(result) instead")
            
            try await sut.insert(user: makeUniqueUser().local)
        } catch {
            #expect(Bool(false), "Expect to succeed but got \(error) error instead")
        }
    }
    
    @Test func test_insert_deliversNoErrorOnNonEmptyCache() async {
        let sut = await makeSUT()
        do {
            try await sut.insert(user: makeUniqueUser().local)
            let result = try await sut.retrieveAll()
            #expect(!result.isEmpty, "Expect the result to be non-empty but empty instead")
            
            try await sut.insert(user: makeUniqueUser().local)
        } catch {
            #expect(Bool(false), "Expect to succeed but got \(error) error instead")
        }
    }
    
    @Test func test_delete_deliversNoErrorOnEmptyCache() async {
        let sut = await makeSUT()
        do {
            try await sut.remove(user: makeUniqueUser().local)
        } catch {
            #expect(Bool(false), "Expect to succeed but got \(error) error instead")
        }
    }
    
    @Test func test_delete_deliversNoErrorOnNonEmptyCache() async {
        let sut = await makeSUT()
        do {
            try await sut.insert(user: makeUniqueUser().local)
            try await sut.remove(user: makeUniqueUser().local)
        } catch {
            #expect(Bool(false), "Expect to succeed but got \(error) error instead")
        }
    }
    
    @Test func test_delete_successfullyRemoveSelectedUserFromCache() async {
        let sut = await makeSUT()
        do {
            let user = makeUniqueUser()
            try await sut.insert(user: user.local)
            var result = try await sut.retrieveAll()
            #expect(!result.isEmpty, "Expect the result to be non-empty but got empty instead")
            
            try await sut.remove(user: user.local)
            result = try await sut.retrieveAll()
            #expect(result.isEmpty, "Expect the result to be empty but got \(result) instead")
            
        } catch {
            #expect(Bool(false), "Expect to succeed but got \(error) error instead")
        }
    }
    
    //MARK: Helpers
    private func makeSUT(file: StaticString = #file, line: UInt = #line) async -> SwiftDataStore {
        let schema = Schema([
            ManagedUser.self,
        ])
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try! ModelContainer(for: schema, configurations: [config])
        let sut = SwiftDataStore(modelContainer: container)
        return sut
    }

}
