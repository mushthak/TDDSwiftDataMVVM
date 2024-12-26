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
    
    init(id: UUID) {
        self.id = id
    }
    
    var local: LocalUserItem {
        return LocalUserItem(id: id)
    }
    
    static func managedUser(from user: LocalUserItem) -> ManagedUser {
        return ManagedUser(id: user.id)
    }
}
