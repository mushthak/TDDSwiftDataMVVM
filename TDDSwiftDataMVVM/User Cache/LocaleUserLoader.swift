//
//  LocaleUserLoader.swift
//  TDDSwiftDataMVVM
//
//  Created by Mushthak Ebrahim on 14/12/24.
//

//MARK: UserLoader
public class LocaleUserLoader: UserLoader {
    public let store: UserStore
    
    public enum Error: Swift.Error {
        case retrieval
        case insertion
        case deletion
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

//MARK: UserCache
extension LocaleUserLoader: UserCache {
    public func saveUser(user: User) async throws {
        do {
            try await store.insert(user: user.toLocal)
        } catch  {
            throw Error.insertion
        }
    }
    
    public func deleteUser() async throws {
        do {
            try await store.remove()
        } catch  {
            throw Error.deletion
        }
    }
}

//MARK: Helpers
private extension User {
    var toLocal: LocalUserItem {
        LocalUserItem(id: self.id)
    }
}

private extension Array where Element == LocalUserItem {
    func toModels() -> [User] {
        return map{User(id: $0.id)}
    }
}
