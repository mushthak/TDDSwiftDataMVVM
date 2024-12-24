//
//  SharedTestHelpers.swift
//  TDDSwiftDataMVVMTests
//
//  Created by Mushthak Ebrahim on 24/12/24.
//
import Foundation
import TDDSwiftDataMVVM

func makeUniqueUser() -> (model: User, local: LocalUserItem) {
    let user = User(id: UUID())
    let localUserItem = user.toLocal
    return (user, localUserItem)
}

func makeTestUsers() -> ([LocalUserItem], [User]) {
    let models = [makeUniqueUser().model, makeUniqueUser().model]
    let local = models.map({LocalUserItem(id: $0.id)})
    return (local, models)
}

private extension User {
    var toLocal: LocalUserItem {
        LocalUserItem(id: self.id)
    }
}
