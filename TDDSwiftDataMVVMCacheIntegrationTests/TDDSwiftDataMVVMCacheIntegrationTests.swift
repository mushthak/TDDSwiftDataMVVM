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
    
    var sharedContainer: ModelContainer
    
    init() async throws {
        let schema = Schema([
            ManagedUser.self,
        ])
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        sharedContainer = try! ModelContainer(for: schema, configurations: [config])
    }

    @Test func test_load_deliversNoItemsOnEmptyCache() async {
        do {
            let sut = makeSUT()
            let result: [User] = try await sut.loadUsers()
            #expect(result.isEmpty)
        } catch  {
            Issue.record("Expected success but got \(error) instead")
        }
    }
    
    @Test func test_load_deliversItemsSavedOnASeperateInstance() async{
        do {
            let sutToPerformSave = makeSUT()
            let sutToPerformLoad = makeSUT()
            let user = makeUniqueUser().model
            
            try await sutToPerformSave.saveUser(user: user)
            
            let result: [User] = try await sutToPerformLoad.loadUsers()
            #expect(result == [user])
        } catch {
            Issue.record("Expected success but got \(error) instead")
        }
    }
    
    //MARK: Helpers
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> LocaleUserLoader {
        let store = SwiftDataStore(modelContainer: sharedContainer)
        let sut = LocaleUserLoader(store: store)
        return sut
    }

}
