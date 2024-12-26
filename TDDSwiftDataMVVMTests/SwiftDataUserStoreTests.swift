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

@Model
final class ManagedUser {
    var id: UUID
    
    init(id: UUID) {
        self.id = id
    }
    
    var local: LocalUserItem {
        return LocalUserItem(id: id)
    }
}

@ModelActor
actor SwiftDataStore: UserStore {
    func retrieveAll() async throws -> [LocalUserItem] {
        let cache = try findUserCache()
        return cache.compactMap{ $0.local }
    }
    
    func insert(user: LocalUserItem) async throws {
        
    }
    
    func remove(user: LocalUserItem) async throws {
        
    }
    
    //MARK: Helpers
    private func findUserCache() throws -> [ManagedUser] {
        let descriptor = FetchDescriptor<ManagedUser>()
        return try modelContext.fetch(descriptor)
    }
}

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
