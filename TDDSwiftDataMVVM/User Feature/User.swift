//
//  User.swift
//  TDDSwiftDataMVVM
//
//  Created by Mushthak Ebrahim on 14/12/24.
//


public struct User: Equatable {
    public let id: UUID
    
    public init(id: UUID) {
        self.id = id
    }
}
