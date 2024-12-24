//
//  UserCache.swift
//  TDDSwiftDataMVVM
//
//  Created by Mushthak Ebrahim on 24/12/24.
//


protocol UserCache {
    func saveUser(user: User) async throws
    func deleteUser() async throws
}
