//
//  UserLoader.swift
//  TDDSwiftDataMVVM
//
//  Created by Mushthak Ebrahim on 14/12/24.
//


protocol UserLoader {
    func loadUsers() async throws -> [User]
}
