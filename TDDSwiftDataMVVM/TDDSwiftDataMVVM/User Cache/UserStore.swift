//
//  UserStore.swift
//  TDDSwiftDataMVVM
//
//  Created by Mushthak Ebrahim on 14/12/24.
//


public protocol UserStore: Sendable {
    func retrieveAll() async throws -> [LocalUserItem]
    func insert(user: LocalUserItem) async throws
    func remove(user: LocalUserItem) async throws
}
