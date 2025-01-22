//
//  UserViewModel.swift
//  TDDSwiftDataMVVM
//
//  Created by Mushthak Ebrahim on 30/12/24.
//

import Foundation


public struct UserViewModel {
    public let id:UUID
    public let name: String
    
    public init(id: UUID,name: String) {
        self.id = id
        self.name = name
    }
}
