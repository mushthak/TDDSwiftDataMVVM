//
//  TDDSwiftDataMVVMCacheIntegrationTests.swift
//  TDDSwiftDataMVVMCacheIntegrationTests
//
//  Created by Mushthak Ebrahim on 29/12/24.
//

import Testing
import SwiftData
import TDDSwiftDataMVVM

struct TDDSwiftDataMVVMCacheIntegrationTests {

    @Test func test_load_deliversNoItemsOnEmptyCache() async {
        do {
            let sut = makeSUT()
            let result: [User] = try await sut.loadUsers()
            #expect(result.isEmpty)
        } catch  {
            Issue.record("Expected success but got \(error) intead")
        }
    }
    
    //MARK: Helpers
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> LocaleUserLoader {
        let schema = Schema([
            ManagedUser.self,
        ])
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try! ModelContainer(for: schema, configurations: [config])
        let store = SwiftDataStore(modelContainer: container)
        let sut = LocaleUserLoader(store: store)
        return sut
    }

}
