//
//  ManagedUser.swift
//  TDDSwiftDataMVVM
//
//  Created by Mushthak Ebrahim on 26/12/24.
//
import Foundation
import SwiftData

@Model
final public class ManagedUser {
    public var id: UUID
    var name: String
    
    init(id: UUID, name: String) {
        self.id = id
        self.name = name
    }
    
    var local: LocalUserItem {
        return LocalUserItem(id: id, name: name)
    }
    
    static func managedUser(from user: LocalUserItem) -> ManagedUser {
        return ManagedUser(id: user.id, name: user.name)
    }
}
