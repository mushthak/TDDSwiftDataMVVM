//
//  LocalUserItem.swift
//  TDDSwiftDataMVVM
//
//  Created by Mushthak Ebrahim on 14/12/24.
//
import Foundation

public struct LocalUserItem: Equatable, Sendable {
    public let id: UUID
    let name: String
    
    public init(id: UUID, name: String) {
        self.id = id
        self.name = name
    }
}
