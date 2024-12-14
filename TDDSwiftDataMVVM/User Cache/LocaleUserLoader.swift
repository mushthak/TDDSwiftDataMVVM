//
//  LocaleUserLoader.swift
//  TDDSwiftDataMVVM
//
//  Created by Mushthak Ebrahim on 14/12/24.
//


public class LocaleUserLoader: UserLoader {
    public let store: UserStore
    
    public enum Error: Swift.Error {
        case retrieval
    }
    
    public init(store: UserStore) {
        self.store = store
    }
    
    public func loadUsers() async throws -> [User] {
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
