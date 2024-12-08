//
//  LoadUserFromCacheUseCaseTests.swift
//  TDDSwiftDataMVVMTests
//
//  Created by Mushthak Ebrahim on 08/12/24.
//

import Testing

protocol UserStore {}

class MockUserStore: UserStore {
    enum ReceivedMessage {}
    
    private(set) var receivedMessages = [ReceivedMessage]()
}

class LocaleUserLoader {
    let store: UserStore
    
    init(store: UserStore) {
        self.store = store
    }
}


struct LoadUserFromCacheUseCaseTests {
    
    @Test func test_init_doesNotMessageStoreUponCreation() async throws {
        let store = MockUserStore()
        let _ = LocaleUserLoader(store: store)
        
        #expect(store.receivedMessages.isEmpty)
    }
    
}
