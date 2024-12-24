//
//  LocalUserItem.swift
//  TDDSwiftDataMVVM
//
//  Created by Mushthak Ebrahim on 14/12/24.
//
import Foundation

public struct LocalUserItem: Equatable {
    let id: UUID
    
    public init(id: UUID) {
        self.id = id
    }
}
