//
//  UserStore.swift
//  TDDSwiftDataMVVM
//
//  Created by Mushthak Ebrahim on 14/12/24.
//


public protocol UserStore {
    func retrieveAll() async throws -> [LocalUserItem]
    func insert(user: LocalUserItem) async throws
    func remove() async throws
}
