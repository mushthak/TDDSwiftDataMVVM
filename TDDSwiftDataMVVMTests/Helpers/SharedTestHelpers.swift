//
//  SharedTestHelpers.swift
//  TDDSwiftDataMVVMTests
//
//  Created by Mushthak Ebrahim on 24/12/24.
//
import Foundation
import TDDSwiftDataMVVM

func makeUniqueUser() -> User {
    return User(id: UUID())
}

func makeTestUsers() -> ([LocalUserItem], [User]) {
    let models = [makeUniqueUser(), makeUniqueUser()]
    let local = models.map({LocalUserItem(id: $0.id)})
    return (local, models)
}
