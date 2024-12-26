//
//  SwiftDataStore.swift
//  TDDSwiftDataMVVM
//
//  Created by Mushthak Ebrahim on 26/12/24.
//
import Foundation
import SwiftData

@ModelActor
public actor SwiftDataStore: UserStore {
    public func retrieveAll() async throws -> [LocalUserItem] {
        let cache = try findUserCache()
        return cache.compactMap{ $0.local }
    }
    
    public func insert(user: LocalUserItem) async throws {
        let managedUser = ManagedUser.managedUser(from: user)
        modelContext.insert(managedUser)
        try modelContext.save()
    }
    
    public func remove(user: LocalUserItem) async throws {
        guard let managedUser = try findManagedUser(for: user.id) else { return }
        modelContext.delete(managedUser)
        try modelContext.save()
    }
    
    //MARK: Helpers
    private func findUserCache() throws -> [ManagedUser] {
        let descriptor = FetchDescriptor<ManagedUser>()
        return try modelContext.fetch(descriptor)
    }
    
    private func findManagedUser(for id: UUID) throws -> ManagedUser? {
        let descriptor = FetchDescriptor<ManagedUser>(
            predicate: #Predicate { $0.id == id }
        )
        return try modelContext.fetch(descriptor).first
    }
}
